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

  # Include you own depencies with nodes global require function:
  # Require the [pushover-notifications](https://github.com/qbit/node-pushover) library
  push = require( 'pushover-notifications' );
  
  # ###Pushover class
  # Create a class that extends the Plugin class and implements the following functions:
  class Pushover extends env.plugins.Plugin
    framework: null
    config: null
    #pushover instance object
    pushover_instance = null
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
      env.logger.info "blah"

      # Require your config shema
      @conf = convict require("./pushover-config-shema")
      # and validate the given config.
      @conf.load config
      @conf.validate()
      # You can use `@conf.get "myOption"` to get a config option.
      
      user = @conf.get "user"
      token = @conf.get "token"
      env.logger.info "user: " + user
      env.logger.info "user: " + token

      pushover_instance = new push( {
        user: user,
        token: token,
      });
      
      default_title = @conf.get "title"
      default_message = @conf.get "message"
      default_url_title = @conf.get "url_title"
      default_url = @conf.get "url"
      default_priority = @conf.get "priority"
      default_sound = @conf.get "sound"
      default_device == @conf.get "device"
      
      framework.ruleManager.addActionHandler(new pushoverActionHandler config)
      # framework.ruleManager.executeAction('"log "blah"' false)
  
  # Create a instance of my plugin
  plugin = new Pushover 

  class pushoverActionHandler extends env.actions.ActionHandler
  
    constructor: (@config) ->
      env.logger.info "action handler constructor"
      return

    executeAction: (actionString, simulate) =>
      env.logger.info "executeAction: " + actionString

      regExpString = '^push.+"(.*)?"+.+"(.*)?"$'
      matches = actionString.match (new RegExp regExpString)
      if matches?
        env.logger.info "executeAction: we have matches"
        title_content = matches[1]
        message_content = matches[2]
        if simulate
          return Q.fcall -> __("would push \"%s\" \"%s\"", title, message)
        else
          return Q.fcall -> 
            msg =
              message: message_content,
              title: title_content,
              sound: 'magic'
              priority: 1
              
            return Q.fcall -> pushover_instance.send(msg).then(__("pushed message"))
            #return null
            
  #module.exports.pushoverActionHandler = pushoverActionHandler

  # and return it to the framework.
  return plugin   
