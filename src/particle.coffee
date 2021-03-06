# Description:
#  Control your particle core/photon
#
# Dependencies:
#  "particle-api-js": "^7.2.3"
#
# Configuration:
#  HUBOT_PARTICLE_ACCESS_TOKEN
#
# Commands:
#  hubot particle list - Generates a list of what devices you own, and displays information about their status
#  hubot particle call <device-id> <function> <params> - Calls a function on one of your devices
#  hubot particle get <device-id> <variable> - Retrieves a variable from one of your devices
#  hubot particle signal <device-id> - Send a signal to the device to shout rainbows
#  hubot particle stop signal <device-id> - Send a signal to the device to stop shouting rainbows
#
# Notes:
#  Inspired by particle-cli syntax:
#   particle list
#   particle call dorito led l7,HIGH
#
# Author:
#  jsolis

Particle = require "particle-api-js"
particle = new Particle()

particleAccessToken = process.env.HUBOT_PARTICLE_ACCESS_TOKEN

module.exports = (robot) ->

  robot.logger.error "HUBOT_PARTICLE_ACCESS_TOKEN not set" unless particleAccessToken

  robot.respond /particle call (.*) (.*) (.*)/i, (res) ->
    device = res.match[1]
    functionName = res.match[2]
    params = res.match[3]

    particle.login({accessToken: particleAccessToken})
      .then (token) ->
        particle.getDevice device, (err, device) ->
          device.callFunction functionName, params, (err, data) ->
            res.send "ERROR calling #{functionName} on #{device.name}: #{err}" if err
            res.send "Received response code #{data.return_value}"
      , (err) ->
        console.log "err", err

# data returned by getAttributes
# {"id":"29003e000747343339373536","name":"dorito","connected":true,"variables":{"ledStatus":"string"},"functions":["led"],"cc3000_patch_version":"wl0: Nov  7 2014 16:03:45 version 5.90.230.12 FWID 01-4d2401b7","product_id":6,"last_heard":"2015-10-27T00:53:37.506Z"}
# dorito [29003e000747343339373536] (Photon) is offline
#  Variables:
#    ledStatus (string)
#   Functions:
#     int led(String args) 
# pretzel [53ff76066667574807262367] (Core) is offline

  robot.respond /particle list/i, (res) ->
    particle.login({accessToken: particleAccessToken})
      .then (token) ->
        particle.listDevices (err, devices) ->
          for device in devices
            device.getAttributes (err, data) ->
              #res.send JSON.stringify(data)
              if err
                res.send "ERROR getting details on #{data.name}: #{err}"
              else
                status = if data.connected then "online" else "offline"
                deviceType = "Photon" if data.product_id == 6
                deviceType = "Core" if data.product_id == 0
                res.send "#{data.name} [#{data.id}] (#{deviceType}) is #{status}"
                if data.variables
                  res.send "  Variables:"
                  for variableName, variableType of data.variables
                    res.send "    #{variableName} (#{variableType})"
                if data.functions
                  res.send "  Functions:"
                  for func in data.functions
                    res.send "    int #{func}(String args)"
      , (err) ->
        console.log "err", err

  robot.respond /particle get (.*) (.*)/i, (res) ->
    device = res.match[1]
    variableName = res.match[2]

    particle.login({accessToken: particleAccessToken})
      .then (token) ->
        particle.getDevice device, (err, device) ->
          device.getVariable variableName, (err, data) ->
            res.send "ERROR getting #{variableName} on #{device.name}: #{err}" if err
            res.send data.result
      , (err) ->
        console.log "err", err

  robot.respond /particle signal (.*)/i, (res) ->
    device = res.match[1]

    particle.login({accessToken: particleAccessToken})
      .then (token) ->
        particle.getDevice device, (err, device) ->
          device.signal (err, data) ->
            res.send "ERROR sending signal to #{device.name}: #{err}" if err
            res.send "Signaling #{device.name}" if data.signaling
            res.send ":( Trouble signaling #{device.name}" unless data.signaling
      , (err) ->
        console.log "err", err

  robot.respond /particle stop\s?signal (.*)/i, (res) ->
    device = res.match[1]

    particle.login({accessToken: particleAccessToken})
      .then (token) ->
        particle.getDevice device, (err, device) ->
          device.stopSignal (err, data) ->
            res.send "ERROR stopping signal to #{device.name}: #{err}" if err
            res.send "Stopped signaling #{device.name}" unless data.signaling
            res.send ":( Trouble stopping signal to #{device.name}" if data.signaling
      , (err) ->
        console.log "err", err
