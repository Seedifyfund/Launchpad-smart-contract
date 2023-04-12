# <h1 align="center"> Foundryx Hardhat Template </h1>

Merging 2 repos: [foundry-rs/hardhat-foundry-template](https://github.com/foundry-rs/hardhat-foundry-template) + [abigger87/femplate](https://github.com/abigger87/femplate)

<br>

## First time with Forge/Foundry?

### Installation

1. Install `foundryup` (toolchain installer):

```bash
curl -L https://foundry.paradigm.xyz | bash
```

2. Trigger foundry installation:

```bash
foundryup
```

**🎉 Foundry is installed! 🎉** <br>

_Anytime you need to get the latest `forge` or `cast` binaries,
you can run `foundryup`._

### Overview: Foundry 🆚 HardHat

1. Tests are run way faster with Foundry than HardHat: [how fast?](https://github.com/foundry-rs/foundry#how-fast)
2. Comes with a number of advanced testing methods: `Fuzz Testing & Differential Testing` _(incoming: Invariant Testing, Symbolic Execution & Mutation Testing)_
3. Tests written **only** in **solidity**

_Notes: If for a specific case/scenario needs to be written in JS/TS you will need to use HardHat (along side Foundry)_

<br><br>

# Getting Started

Update git submodules & install repo's forge libraries

```
yarn install & git submodule update --init --recursive && forge install
```

### Writing Tests with Foundry

Create a test file for your contract in the `src/tests/` directory.

To learn more about writing tests in Solidity for Foundry, reference Rari Capital's [solmate](https://github.com/Rari-Capital/solmate/tree/main/src/test) repository created by [@transmissions11](https://twitter.com/transmissions11).

# Run Tests

```
forge test --gas-report --watch
```

`watch` allows to trigger test on every change in test files

# Internal audits

For internal audits we will use tools like `Echidna, Etheno, Manticore, Slither & Rattle`. <br>
We also need to check our code against well known vulnerabilities from [Not So Smart Contracts repository](https://github.com/trailofbits/not-so-smart-contracts) _(included in the image)_

## Install and run the toolkit

```
docker run -it -v ${PWD}:/share trailofbits/eth-security-toolbox
```

You might need to change default `solc` version with:

```
solc-select use 0.8.13
```

File of the current folder will be in `/share` folder of the container. When running a command with slither it look like:

```
slither /share/src/Token.sol --config-file /share/slither.config.json
```

# Forge

## Deploy: local network via Anvil

First, start Anvil:

```
anvil
```

Then run the following script with one of the private keys given to you by Anvil:

```
forge script scripts/Token.s.sol:DeployToken --fork-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast -vvvv
```

## Deploy: existing network

Create an `.env` file based on `.env.example` & fill it with your data. Then run:

```
source .env
forge script scripts/Token.s.sol:DeployToken --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $EXPLORER_KEY -vvvv
```

## Other commands

Install libraries with Foundry which work with Hardhat

```
forge install rari-capital/solmate # Already in this repo
```

Updating a library

```
forge update lib/<dep>
```

Removing a library

```
forge update lib/<dep>
```

## HardHat compatibility

Whenever you install new libraries using Foundry, make sure to update your `remappings.txt`.

Follow steps [here](https://book.getfoundry.sh/config/hardhat.html) to enable HardHat compatibility

# Formatting

## Solhint

### Disable solhint on current line

Disable completely solhint

```
// solhint-disable-next-line
```

Disable some solhint rules

```
// solhint-disable-next-line no-empty-blocks not-rely-on-time
```

### Disable solhint for a group of lines

Disalbe completely solhint

```
/* solhint-disable */
function transferTo(address to, uint amount) public {
    require(tx.origin == owner);
    to.call.value(amount)();
}
/* solhint-enable */
```

Disable some solhint rules

```
  /* solhint-disable avoid-tx-origin not-rely-on-time */
  function transferTo(address to, uint amount) public {
    require(tx.origin == owner);
    to.call.value(amount)();
  }
  /* solhint-enable avoid-tx-origin not-rely-on-time */
```

## Why Husky

Husky allows to manage git hooks and trigger actions when commiting, e.g. `npx prettier writte .`

## Create a hook on commits

```
npx husky add .husky/pre-commit "npm test"
git add .husky/pre-commit
```

_reference: [doc](https://typicode.github.io/husky/#/?id=create-a-hook)_

Some specific package might need specific hooks:

```
npx husky add .husky/commit-msg 'npx --no commitlint --edit "$1"'
```

_reference: [doc](https://typicode.github.io/husky/#/?id=automatic-recommended)_

---

## Miscellaneous

### IDE interactive rebase

In order to rebase interactively in your IDE (e.g. VSCode), copy this in your terminal:

```
git config --global core.editor "code --wait"
```
