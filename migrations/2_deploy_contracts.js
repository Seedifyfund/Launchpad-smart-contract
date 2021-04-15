var Seedify = artifacts.require("SeedifyFundsContract");

module.exports = function(deployer) {
  deployer.deploy(Seedify);
};
