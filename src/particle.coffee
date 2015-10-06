# Description:
#  Control your particle core/photon
#
# Dependencies:
#  "spark": "^1.0.0"
#
# Configuration:
#  HUBOT_PARTICLE_ACCESS_TOKEN
#
# Commands:
#  hubot particle list - Generates a list of what devices you own, and displays information about their status
#  hubot particle call <device-id> <function> <params> - Calls a function on one of your devices
#
# Notes:
#  Inspired by particle-cli syntax:
#   particle list
#   particle call dorito led l7,HIGH
#
# Author:
#  jsolis

spark = require "spark"

particleAccessToken = process.env.HUBOT_PARTICLE_ACCESS_TOKEN

module.exports = (robot) ->

  robot.logger.error "HUBOT_PARTICLE_ACCESS_TOKEN not set" unless particleAccessToken

  robot.respond /particle call (.*) (.*) (.*)/i, (res) ->
    device = res.match[1]
    functionName = res.match[2]
    params = res.match[3]

    spark.login({accessToken: particleAccessToken})
      .then (token) ->
        spark.getDevice device, (err, device) ->
          device.callFunction functionName, params, (err, data) ->
            res.send "ERROR calling #{functionName} on #{device}" if err
            res.send "Received response code #{data.return_value}"
      , (err) ->
        console.log "err", err

  robot.respond /particle list/i, (res) ->
    spark.login({accessToken: particleAccessToken})
      .then (token) ->
        spark.listDevices (err, devices) ->
          for device in devices
            status = if device.connected then "online" else "offline"
            upgrade = if device.requiresUpgrade then " (requires upgrade)" else ""
            res.send "#{device.name} is #{status}#{upgrade}"
      , (err) ->
        console.log "err", err

