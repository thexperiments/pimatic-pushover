# #pushoverNotification configuration options

# Defines a `node-convict` config-shema and exports it.
module.exports 
  id:
    doc: "ID of the device for use with pimatic"
    format: "string"
    default: null
  name:
    doc:"Name for representation in pimatic GUI"
    format: "string"
    default: null
  title:
    doc: "Title for the notification"=
    format: "string"
    default: null
  message: #only this is required
    doc: "Message for the notification"
    format: "string"
    default: null
  url:
    doc: "URL which to send with the notification"
    format: "url"
    default: null
  url_title:
    doc: "Title of the URL which to send with the notification"
    format: "string"
    default: null
  priority:
    doc: "Priority of the notification: send as -1 to always send as a quiet notification, 1 to display as high-priority and bypass the user's quiet hours, or 2 to also require confirmation from the user"
    format: "int"
    default: 0
  sound:
    doc: "Sound for the notification, see https://pushover.net/api#sounds"
    format: "string"
    default: pushover
    