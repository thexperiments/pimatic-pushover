# #Pushover Plugin

# This is an plugin to send push notifications via pushover

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take 
  # a look at the dependencies section in pimatics package.json

  # Require [convict](https://github.com/mozilla/node-convict) for config validation.
  convict = env.require "convict"

  # Require the [Q](https://github.com/kriskowal/q) promise library
  Q = env.require 'q'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  #Matcher to match the input predicate and supply autocomplete
  M = env.matcher

  # Include you own depencies with nodes global require function:
  # Require the [pushover-notifications](https://github.com/qbit/node-pushover) library
  push = require 'pushover-notifications'
  
  pushoverService = null

  # ###Pushover class
  class Pushover extends env.plugins.Plugin

    # ####init()
    init: (app, @framework, config) =>
      # Require your config shema
      @conf = convict require("./pushover-config-schema")
      # and validate the given config.
      @conf.load config
      @conf.validate()
      # You can use `@confmyOption"` to get a config option.
      
      user = config.user
      token = config.token
      env.logger.debug "pushover: user= #{user}"
      env.logger.debug "pushover: token = #{token}"

      pushoverService = new push( {
        user: user,
        token: token,
      })
      
      @framework.ruleManager.addActionProvider(new PushoverActionProvider @framework, @conf)
  
  # Create a instance of my plugin
  plugin = new Pushover 

  class PushoverActionProvider extends env.actions.ActionProvider
  
    constructor: (@framework, @conf) ->
      return

    parseAction: (input, context) =>

      defaultTitle = @conf.get('title')
      defaultMessage = @conf.get('message')
      defaultPriority = @conf.get('priority')
      defaultSound = @conf.get('sound')
      defaultDevice = @conf.get('device')

      # Helper to convert 'some text' to [ '"some teyt"' ]
      strToTokens = (str) => ["\"#{str}\""]

      titleTokens = strToTokens defaultTitle
      messageTokens = strToTokens defaultMessage
      priority = defaultPriority
      sound = defaultSound
      device = defaultDevice

      setTitle = (m, tokens) => titleTokens = tokens
      setMessage = (m, tokens) => messageTokens = tokens
      setPriority = (m, p) => priority = p

      m = M(input, context)
        .match('send ', optional: yes)
        .match(['push','pushover','notification'])

      next = m.match(' title:').matchStringWithVars(setTitle)
      if next.hadMatch() then m = next

      next = m.match(' message:').matchStringWithVars(setMessage)
      if next.hadMatch() then m = next

      next = m.match(' priority:').matchNumber(setPriority)
      if next.hadMatch() then m = next

      if m.hadMatch()
        match = m.getFullMatch()

        assert Array.isArray(titleTokens)
        assert Array.isArray(messageTokens)
        assert(not isNaN(priority))

        return {
          token: match
          nextInput: input.substring(match.length)
          actionHandler: new PushoverActionHandler(
            @framework, titleTokens, messageTokens, priority, sound, device
          )
        }
            

  class PushoverActionHandler extends env.actions.ActionHandler 

    constructor: (@framework, @titleTokens, @messageTokens, @priority, @sound, @device) ->

    executeAction: (simulate, context) ->
      Q.all( [
        @framework.variableManager.evaluateStringExpression(@titleTokens)
        @framework.variableManager.evaluateStringExpression(@messageTokens)
      ]).then( ([title, message]) =>
        if simulate
          # just return a promise fulfilled with a description about what we would do.
          return __("would push message \"%s\" with title \"%s\"", message, title)
        else
          msg = {
            message: message
            title: title
            sound: @sound
            priority: @priority
          }

          return Q.ninvoke(pushoverService, "send", msg).then( => 
            __("pushover message sent successfully") 
          )
      )

  module.exports.PushoverActionHandler = PushoverActionHandler

  # and return it to the framework.
  return plugin   
