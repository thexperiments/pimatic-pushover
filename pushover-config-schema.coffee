module.exports = {
  title: "pushover config options"
  type: "object"
  properties: 
    user:
      description:"Pushover user hash"
      type: "string"
      default: ""
    token:
      description:"Pushover token"
      type: "string"
      default: ""
    title: #might be overwritten by predicate
      description:"Title for the notification"
      type: "string"
      default: ""
    message: #might be overwritten by predicate
      description:"Message for the notification"
      type: "string"
      default: ""
    url: #might be overwritten by predicate, not implemented yet
      description:"URL which to send with the notification"
      format: "url"
      default: "https://github.com/thexperiments/pimatic-pushover"
    urlTitle: #might be overwritten by predicate, not implemented yet
      description:"Title of the URL which to send with the notification"
      type: "string"
      default: ""
    priority: #might be overwritten by predicate
      description:"""Priority of the notification: send as -1 to always send as a quiet notification, 1 
        to display as high-priority and bypass the user's quiet hours, or 2 to also require 
        confirmation from the user"""
      type: "integer"
      default: 0
    sound: #might be overwritten by predicate, not implemented yet
      description:"Sound for the notification, see https://pushover.net/api#sounds"
      type: "string"
      default: "pushover"
    device: #might be overwritten by predicate, not implemented yet
      description:"device to send the notifcation to"
      type: "string"
      default: ""
}