pimatic-pushover
=======================

A plugin for sending [pushover](https://pushover.net/) notifications in pimatic.

Forked from and original created by: [thexperiments](https://github.com/thexperiments/pimatic-pushover)


Configuration
-------------
You can load the backend by editing your `config.json` to include:

    {
      "plugin": "pushover",
      "user": "xxxxxxxxxxxxxxxxxxxxxxxxxx",
      "token": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }

in the `plugins` section. For all configuration options see 
[pushover-config-schema](pushover-config-schema.coffee)

Currently you can send pushover notifications via action handler within rules.

Example:
--------

    if it is 08:00 push title:"Good morning!" message:"Good morning Dave!" priority:1

in general: if X then push title:

    "title of the push notification" message:"message for the notification" [priority:-1 - 1]

Find priorities here at [pushover](https://pushover.net/api#priority) be aware that priority 2 currently crashes pimatic!