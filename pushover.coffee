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
  
  pushover_instance = null

  # ###Pushover class
  # Create a class that extends the Plugin class and implements the following functions:
  class Pushover extends env.plugins.Plugin
    framework: null
    config: null

    default_title = null
    default_message = null
    default_url_title = null
    default_url = null
    default_priority = null
    default_sound = null
    default_device = null

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #  
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins` section
    #     of the config.json file 
    # 
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

      pushover_instance = new push( {
        user: user,
        token: token,
      });
      
      framework.ruleManager.addActionHandler(new pushoverActionHandler config)
      # framework.ruleManager.executeAction('"log "blah"' false)
  
  # Create a instance of my plugin
  plugin = new Pushover 

  class pushoverActionHandler extends env.actions.ActionHandler
  
    constructor: (@config) ->
      return

    executeAction: (actionString, simulate, context) =>
      #env.logger.debug "executeAction: " + actionString

      regExpString = 
        '^push.+(?:title:"(.*)")\\s*'+
        '(?:message:"(.*)")\\s*'+
        '(?:priority:(-?[0-2]))?\\s*$'

      #env.logger.debug "executeAction, regExpString: " + regExpString

      matches = actionString.match (new RegExp regExpString)

      matchCount = 0

      title_content = null
      message_content = null
      priority_content = null

      setTitle = (m, t) => title_content = t
      setMessage = (m, mc) => message_content = mc
      setPriority = (m, p) => priority_content = p

      m = M(actionString, context)
        .match('send ', optional: yes)
        .match(['push','pushover','notification'])

      next = m.match(' title:').matchString(setTitle)
      unless next.hadNoMatches()
        m = next

      next = m.match(' message:').matchString(setMessage)
      unless next.hadNoMatches()
        m = next

      next = m.match(' priority:').matchNumber(setPriority)
      unless next.hadNoMatches()
        m = next
      #m.inAnyOrder()
      m.onEnd( => matchCount++)

      if matchCount is 1
        env.logger.debug "executeAction: we have matches, simulate:#{simulate}"

        if simulate
          return Q.fcall -> 
            env.logger.debug "executeAction: we simulate the action"
        else
          if !message_content
            message_content = @config.title
          if !title_content
            title_content = @config.message
          if !priority_content
            priority_content = @config.priority

          default_url_title = @configurl_title
          default_url = @config.url
          default_sound = @config.sound
          default_device = @config.device

          return Q.fcall -> 
            msg =
              message: message_content
              title: title_content
              sound: default_sound
              priority: priority_content

            env.logger.debug "executeAction: we send the message"

            return Q.ninvoke(pushover_instance, "send", msg).then(-> __("pusover message sent successfully") )
      else if matchCount > 1
        context.addError(""""#{actionString.trim()}" is ambiguous.""")
      #return result
            
  module.exports.pushoverActionHandler = pushoverActionHandler

  # and return it to the framework.
  return plugin   
