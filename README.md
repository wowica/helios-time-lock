# Helios Time Lock

This is a variation of the Helios [time-lock smart contract](https://www.hyperion-bt.org/Helios-Book/cli/example-time-lock.html).  
The Helios code is in [validator.hl](validator.hl).  
The [validator.js](validator.js) file compiles Helios and generates the final artifacts.

## Setup

The [Helios](https://github.com/Hyperion-BT/Helios) library is _pure_ JavaScript 🎉   
Install dependencies with either `npm install` or `yarn`.  

## Compiling and Generating Artifacts

To generate all the artifacts needed to interact with the smart contract, run the following:

```
$ npm run compile
```

The artifacts should be generated on the `dist`folder.