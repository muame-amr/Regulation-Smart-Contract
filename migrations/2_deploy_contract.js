const SimpleRegulator = artifacts.require("SimpleRegulator");

module.exports = function (deployer) {
  deployer.deploy(SimpleRegulator);
};
