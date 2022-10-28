# Launchpad Smart Contract

## Pre-requisite

* Hardhat
* Solidity
* Node
* NPM
* Web3.js
* Metamask
* Binance Network

### Steps For Test And Deployment

## Compile & Clean

```shell
npx hardhat compile
npx hardhat clean
```

## Gas Reporter

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

## Flatten

If the contracts folder contains a multiple contracts, the one you want to flatten, the execution code can omit the file you want to flatten. That is, you can use:

```shell
$ npx hardhat flatten ./contracts/Token.sol > flattenedToken.sol
```

However, if the contracts folder has more than one contract, HardHat will flatten all existing contracts into a single file. That is, you can use:

```shell
$ npx hardhat flatten  > flattenedAll.sol
```

## Deploy

As general rule, you can target any network from your Hardhat config using:

```shell
npx hardhat run --network <your-network> scripts/deploy.js
```

## Verify

Once your contract is ready, the next step is to deploy it to a live network and verify its source code. Verifying a contract means making its source code public.

The first thing you need is an API key from Etherscan. Open your Hardhat config and add the API key you just created.

```shell
npx hardhat verify --network <your-network> --constructor-args scripts/arguments.js <contract-address>
```

After the task is successfully executed, you'll see a link to the publicly verified code of your contract.
