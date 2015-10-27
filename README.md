# Hubot Particle Photon Adapter

## Description

This Hubot adapter uses the ParticleJS library to communicate and control your Particle Photon / Particle Core devices.
The syntax was inspired by the particle cli utility.

## Supported Features
* list
* callFunction

## Planned Features
* getVariable
* signal
* stopSignal
* publish
* subscribe

## Sample Interaction

To get a list of your claimed devices associated with your access token
```
user> Hubot particle list
hubot> dorito is online
hubot> pretzel is offline
```

To call a function on your device that has been uploaded to your device and registered to the Particle cloud
```
user> Hubot particle call <device-id> <function> <params>
hubot> Received response code 1
```

See [`src/particle.coffee`](src/particle.coffee) for full documentation.

## Data
[![NPM](https://nodei.co/npm/hubot-particle.png?downloads=true&stars=true)](https://nodei.co/npm/hubot-particle.png?downloads=true&stars=true)

## Installation

In hubot project repo, run:

`npm install hubot-particle --save`

Then add **hubot-particle** to your `external-scripts.json`:

```json
["hubot-particle"]
```
You will need to set one environment variable to use this adapter.

```
export HUBOT_PARTICLE_ACCESS_TOKEN=abc123
```
You can get your Particle access token from the "Settings" section of [Particle's Web IDE](https://build.particle.io/build/new)


## Contribute

Just send pull request or file an issue !

