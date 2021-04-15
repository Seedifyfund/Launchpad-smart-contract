const Seedify = artifacts.require('SeedifyFundsContract');

// test case to check the smartcontract deployed correctly or not.
contract("SeedifyFund", async accounts => {
  it("is deployed correctly?", async () => {
    const SeedifyInstance = await Seedify.deployed();
    //console.log(SeedifyInstance.address);
    assert(SeedifyInstance.address !== '');
  });
});

// test case written to start the token sale
contract('SeedifyFund', async accounts => {
  it('is token sale is started?', async () => {
    const SeedifyInstance = await Seedify.deployed();
    const result = await SeedifyInstance.startTokenSale();
    assert(result != false);
  });
});

//Add and check the address in Whitelist tier One
contract("SeedifyFund", async accounts => {
  it("Add and check the address in Whitelist tier One", async () => {
    const SeedifyInstance = await Seedify.deployed();
    const accounts = await web3.eth.getAccounts();
    const owner = accounts[0];
    await SeedifyInstance.addWhitelistOne(owner)
    const result = await SeedifyInstance.getWhitelistOne(owner);
    assert(result != false);

  });
});

//Add and check the address in Whitelist tier two
contract("SeedifyFund", async accounts => {
  it("Add and check the address in Whitelist tier two", async () => {
    const SeedifyInstance = await Seedify.deployed();
    const accounts = await web3.eth.getAccounts();
    const owner = accounts[1];
    await SeedifyInstance.addWhitelistTwo(owner)
    const result = await SeedifyInstance.getWhitelistTwo(owner);
    assert(result != false);

  });
});

//Add and check the address in Whitelist tier three
contract("SeedifyFund", async accounts => {
  it("Add and check the address in Whitelist tier three", async () => {
    const SeedifyInstance = await Seedify.deployed();
    const accounts = await web3.eth.getAccounts();
    const owner = accounts[2];
    await SeedifyInstance.addWhitelistThree(owner)
    const result = await SeedifyInstance.getWhitelistThree(owner);
    assert(result != false);

  });
});

// To check the whitelist for tier one
contract('SeedifyFund', async accounts => {
  it("Pay One BNB to Check In WhiteListOne, is first tier payment working correctly?", async () => {
    const instance = await Seedify.deployed();

    const value = 1;
    const accounts = await web3.eth.getAccounts();

    await instance.startTokenSale();
    await instance.addWhitelistOne(accounts[0]);
    let result = await web3.eth.sendTransaction({ from: accounts[0], to: instance.address, value: value });
    assert(result != false);
  })
})

// To check the whitelist for tier two
contract('SeedifyFund', async accounts => {
  it("Pay Two BNB to Check In WhiteListTwo, is second tier payment working correctly?", async () => {
    const instance = await Seedify.deployed();

    const value = 2;
    const accounts = await web3.eth.getAccounts();

    await instance.startTokenSale();
    await instance.addWhitelistTwo(accounts[0]);
    let result = await web3.eth.sendTransaction({ from: accounts[0], to: instance.address, value: value });
    assert(result != false);
  })
})

// To check the whitelist for tier three
contract('SeedifyFund', async accounts => {
  it("Pay Four BNB to Check In WhiteListThree, is third tier payment working correctly?", async () => {
    const instance = await Seedify.deployed();

    const value = 4;
    const accounts = await web3.eth.getAccounts();

    await instance.startTokenSale();
    await instance.addWhitelistThree(accounts[0]);
    let result = await web3.eth.sendTransaction({ from: accounts[0], to: instance.address, value: value });
    assert(result != false);
  })
})