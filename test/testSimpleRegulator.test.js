const SimpleRegulator = artifacts.require("SimpleRegulator");

contract("SimpleRegulator", () => {
  let simpleRegulator;

  before(async () => {
    // deployed() return a js object pointing to an already deployed smart contract
    simpleRegulator = await SimpleRegulator.deployed();
  });

  it("Should deploy properly", async () => {
    // console.log(simpleRegulator.address);
    assert(simpleRegulator.address !== "");
  });

  it("Should set threshold to 20 ether", async () => {
    const threshold = await simpleRegulator.threshold;
    assert(simpleRegulator.threshold === threshold);
  });

  it("Balance should be 20 ether", async () => {
    simpleRegulator.deposit(5);
    const balance = await simpleRegulator.getBalance();
    assert(balance.toNumber() === 20);
  });
});
