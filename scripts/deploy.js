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
    1667912083, // _saleStartTime
    1670504112, // _saleEndTime
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
    "0xC2e047e7648d4A2107431b356090F5Ed8BBfeb99", // _tokenAddress
    "0x97b2a21b235c5F53b797C043c7Ac947Fa09D8637" // _IGOTokenAddress
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
