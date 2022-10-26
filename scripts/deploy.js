// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const Seedify = await hre.ethers.getContractFactory("contracts/SeedifyFund/SeedifyFundBUSD.sol:SeedifyFundsContract");
  const seedify = await Seedify.deploy(
    10000000000000000000000n, // _maxCap
    1666596376, // _saleStartTime
    1669274776, // _saleEndTime
    "0xd733Dea83fFf749aEa99bbA541F6F1157A9Cb588", // _projectOwner
    [100000000000000000000n,
    200000000000000000000n,
    300000000000000000000n,
    400000000000000000000n,
    500000000000000000000n,
    600000000000000000000n,
    700000000000000000000n,
    800000000000000000000n,
    900000000000000000000n], // _tiersValue
    100, // _totalparticipants
    "0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee" // _tokenAddress
  );

  await seedify.deployed();

  console.log("Seedify deployed to:", seedify.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
