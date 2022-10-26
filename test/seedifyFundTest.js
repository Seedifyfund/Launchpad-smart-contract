const { expect } = require("chai");
const { ethers } = require("hardhat");
var assert = require('assert')

describe("SeedifyFund", function () {
  let SeedifyInstance;

  it("is deployed correctly?", async function () {
    const Seedify = await ethers.getContractFactory("contracts/SeedifyFund/SeedifyFundBUSD.sol:SeedifyFundsContract");
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

    SeedifyInstance = await seedify.deployed();
    console.log(SeedifyInstance.address);
    assert(SeedifyInstance.address !== '');
  });

  it('is token sale is started?', async () => {
    const StartTime = await SeedifyInstance.saleStartTime();
    assert(Date.now() > StartTime);
  });

  it("Add and check the address in Whitelist tier One", async () => {
    const accounts = await ethers.getSigners();
    await SeedifyInstance.addWhitelist(1, accounts[0].address);
    const result = await SeedifyInstance.getWhitelist(1, accounts[0].address);
    console.log(result)
    assert(result != false);
  });

  it("Add and check the address in Whitelist tier Two", async () => {
    const accounts = await ethers.getSigners();
    await SeedifyInstance.addWhitelist(2, accounts[1].address);
    const result = await SeedifyInstance.getWhitelist(2, accounts[1].address);
    console.log(result)
    assert(result != false);
  });

  it("Add and check the address in Whitelist tier Three", async () => {
    const accounts = await ethers.getSigners();
    await SeedifyInstance.addWhitelist(3, accounts[2].address);
    const result = await SeedifyInstance.getWhitelist(3, accounts[2].address);
    console.log(result)
    assert(result != false);
  });
});