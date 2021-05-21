const Migrations = artifacts.require("Migrations");
const SharedWallet = artifacts.require("SharedWallet")

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(SharedWallet);
};
