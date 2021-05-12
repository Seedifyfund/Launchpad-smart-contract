# update
Seedify.fund Launcpad Smart Contract on Binance Smart Chain

## Pre-requisite

* Truffle v5.1.8 (core: 5.1.8)
* Solidity - 0.4.26 (solc-js)
* Node v12.13.1
* NPM v6.12.1
* Web3.js v1.2.1
* Metamask

### Steps For Deployment

All steps are performed in directory Update

* truffle develop

    --IN truffle console
    * compile
    * migrate

    OR in another Terminal
    * truffle compile 
    * truffle migrate --reset

## To run the test cases on development mode run

* truffle test

## Using network 'development'.


truffle(develop)> truffle test
Using network 'develop'.



Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



  Contract: SeedifyFund
    ✓ is deployed correctly?

  Contract: SeedifyFund
    ✓ is token sale is started? (69ms)

  Contract: SeedifyFund
    ✓ Add and check the address in Whitelist tier One (123ms)

  Contract: SeedifyFund
    ✓ Add and check the address in Whitelist tier two (111ms)

  Contract: SeedifyFund
    ✓ Add and check the address in Whitelist tier three (108ms)

  Contract: SeedifyFund
    ✓ Pay One BNB to Check In WhiteListOne, is first tier payment working correctly? (233ms)

  Contract: SeedifyFund
    ✓ Pay Two BNB to Check In WhiteListTwo, is second tier payment working correctly? (181ms)

  Contract: SeedifyFund
    ✓ Pay Four BNB to Check In WhiteListThree, is third tier payment working correctly? (191ms)


  8 passing (1s)
