# #my-plugin configuration options

# Declare your config option for your plugin here. 

# Defines a `node-convict` config-shema and exports it.
module.exports =
  user:
    doc: "Pushover user hash"
    format: String
    default: ""
  token:
    doc: "Pushover token"
    format: "string"
    default: ""