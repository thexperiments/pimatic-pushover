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
  title: #might be overwritten by predicate
    doc: "Title for the notification"=
    format: "string"
    default: null
  message: #might be overwritten by predicate
    doc: "Message for the notification"
    format: "string"
    default: null
  url: #might be overwritten by predicate
    doc: "URL which to send with the notification"
    format: "url"
    default: null
  url_title: #might be overwritten by predicate
    doc: "Title of the URL which to send with the notification"
    format: "string"
    default: null
  priority: #might be overwritten by predicate
    doc: "Priority of the notification: send as -1 to always send as a quiet notification, 1 to display as high-priority and bypass the user's quiet hours, or 2 to also require confirmation from the user"
    format: "int"
    default: 0
  sound: #might be overwritten by predicate
    doc: "Sound for the notification, see https://pushover.net/api#sounds"
    format: "string"
    default: pushover
  device: #might be overwritten by predicate
    doc: "device to send the notifcation to"
    format: "string"
    default: null