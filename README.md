# Hubot Particle Photon Script

## Description

This Hubot script uses the ParticleJS library to communicate and control your Particle Photon / Particle Core devices.
The syntax was inspired by the particle cli utility.

## Supported Features
* list
* callFunction
* getVariable
* signal
* stopSignal

## Planned Features
* publish
* subscribe

## Sample Interaction

To get a list of your claimed devices associated with your access token
```
user> Hubot particle list
hubot> Your devices:
hubot> dorito [123abc] (Photon) is online
hubot>  Variables:
hubot>    ledStatus (string)
hubot>  Functions:
hubot>    int led(String args)
hubot> pretzel [567def] (Core) is offline
```

To call a function on your device that has been uploaded to your device and registered to the Particle cloud
```
doc> Hubot particle call <device-id> <function> <params>
user> Hubot particle call dorito led on
hubot> Received response code 1
```

To retrieve a variable
```
doc> Hubot particle get <device-id> <variable>
user> Hubot particle get dorito ledStatus
hubot> on
```

To shout rainbows
```
doc> Hubot particle signal <device-id>
user> Hubot particle signal dorito
hubot> Signaling dorito
```

To stop shouting rainbows
```
doc> Hubot particle stop signal <device-id>
user> Hubot particle stop signal dorito
hubot> Stopped signaling dorito
```

See [`src/particle.coffee`](src/particle.coffee) for full documentation.

## Data
[![NPM](https://nodei.co/npm/hubot-particle.png?downloads=true&stars=true)](https://nodei.co/npm/hubot-particle.png?downloads=true&stars=true)

## Installation

In hubot project repo, run:

```
npm install hubot-particle --save
```

Then add **hubot-particle** to your `external-scripts.json`:

```json
["hubot-particle"]
```
You will need to set one environment variable to use this script.

```
export HUBOT_PARTICLE_ACCESS_TOKEN=abc123
```
You can get your Particle access token from the "Settings" section of [Particle's Web IDE](https://build.particle.io/build/new)


## Contribute

Just send pull request or file an issue !

