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
  
  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class pushover extends env.plugins.Plugin

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
      @conf = convict require("./pushover-config-shema")
      # and validate the given config.
      @conf.load config
      @conf.validate()
      # You can use `@conf.get "myOption"` to get a config option.

    # ####createDevice()
    # The `createDevice` function is called by the framework for every device in the `devices`
    # section of the config.json file.
    # 
    # You should create your device here, if the class of the given deviceConfig matches on of 
    # yours.
    # 
    # #####params:
    #  * `deviceConfig` the properties the user specified in the `devices` section of the 
    #    config.json file
    # 
    createDevice: (deviceConfig) =>
      # if the class option of the given config is...
      switch deviceConfig.class
        # ...matches your switch class
        when "PushoverNotification" 
          # then create a instance of your device and register it
          @framework.registerDevice(new PushoverNotification deviceConfig)
          # and return true.
          return true
        # ... not matching your classes
        else
          # then return false.
          return false

  # ###PushoverNotification class
  # An class to send pushover notifications
  class PushoverNotification extends env.devices.Actuator

    # ####constructor()
    # Your constructor function must assign a name and id to the device.
    constructor: (deviceConfig) ->
      # Require your actuator config shema
      @conf = convict require("./actuator-config-shema")
      # and validate the given device config.
      @conf.load deviceConfig
      @conf.validate()
      # Then assign the given name and id to the object.
      @name = conf.get "name"
      @id = conf.get "id"


  # ###Finally
  # Create a instance of my plugin
  myPlugin = new MyPlugin
  # and return it to the framework.
  return myPlugin