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
    format: String
    default: ""
  title: #might be overwritten by predicate
    doc: "Title for the notification"
    format: String
    default: ""
  message: #might be overwritten by predicate
    doc: "Message for the notification"
    format: String
    default: ""
  url: #might be overwritten by predicate, not implemented yet
    doc: "URL which to send with the notification"
    format: "url"
    default: "https://github.com/thexperiments/pimatic-pushover"
  urlTitle: #might be overwritten by predicate, not implemented yet
    doc: "Title of the URL which to send with the notification"
    format: String
    default: ""
  priority: #might be overwritten by predicate
    doc: """Priority of the notification: send as -1 to always send as a quiet notification, 1 
      to display as high-priority and bypass the user's quiet hours, or 2 to also require 
      confirmation from the user"""
    format: "nat"
    default: 0
  sound: #might be overwritten by predicate, not implemented yet
    doc: "Sound for the notification, see https://pushover.net/api#sounds"
    format: String
    default: "pushover"
  device: #might be overwritten by predicate, not implemented yet
    doc: "device to send the notifcation to"
    format: String
    default: ""