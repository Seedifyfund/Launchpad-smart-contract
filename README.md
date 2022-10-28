# Launchpad Smart Contract

## Pre-requisite

* Hardhat
* Solidity
* Node
* NPM
* Web3.js
* Metamask
* Binance Network

### Steps For Deployment

## Compile & Clean

```shell
npx hardhat compile
npx hardhat clean
```

## hardhat-gas-reporter

```shell
npm install hardhat-gas-reporter --save-dev
```
And add the following to your hardhat.config.js:

```shell
require("hardhat-gas-reporter");
```

Or, if you are using TypeScript, add this to your hardhat.config.ts:

```shell
import "hardhat-gas-reporter"
```

## Test

```shell
npx hardhat node

Open New Terminal
npx hardhat accounts
npx hardhat test
```
## Compiling your contracts...

> Compiled 1 Solidity file successfully

    ✓ is deployed correctly? (3302471 gas)
    ✓ is token sale is started? (3233874 gas)
    true
    ✓ Add and check the address in Whitelist tier One (3302437 gas)
    true
    ✓ Add and check the address in Whitelist tier Two (137149 gas)
    true
    ✓ Add and check the address in Whitelist tier Three (137183 gas)
    true
    5 passing (13s)
