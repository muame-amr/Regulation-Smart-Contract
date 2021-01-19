import Web3 from "web3";
import SimpleRegulator from "../build/contracts/SimpleRegulator.json";

let web3;
let simpleRegulator;

const initWeb3 = () => {
  return new Promise((resolve, reject) => {
    // Case 1: new metamask is present
    if (typeof window.ethereum !== "undefined") {
      const web3 = new Web3(window.ethereum);
      window.ethereum
        .enable()
        .then(() => {
          resolve(new Web3(window.ethereum));
        })
        .catch((e) => {
          reject(e);
        });
      return;
    }
    // Case 2: old metamask is present
    if (typeof window.web3 !== "undefined") {
      return resolve(new Web3(window.web3.currentProvider));
    }
    // Case 3: no metamask, connect to Ganache
    resolve(new Web3("https://localhost:9545"));
  });
};

const initContract = () => {
  const deploymentKey = Object.keys(SimpleRegulator.networks)[0];
  return new web3.eth.Contract(
    SimpleRegulator.abi,
    SimpleRegulator.networks[deploymentKey].address
  );
};

const initApp = () => {
  const $depositData = document.getElementById("deposit");
  const $withdrawData = document.getElementById("withdraw");
  const $balance = document.getElementById("balance");
  const $acc = document.getElementById("accounts");
  let accounts = [];

  web3.eth
    .getAccounts()
    .then((_accounts) => {
      accounts = _accounts;
      return simpleRegulator.methods.getBalance().call();
    })
    .then((result) => {
      $balance.innerHTML = result;
    });

  web3.eth
    .getAccounts()
    .then((_accounts) => {
      accounts = _accounts;
      return simpleRegulator.methods.getAllClients().call();
    })
    .then((result) => {
      $acc.innerHTML = result;
    });

  const getData = () => {
    simpleRegulator.methods
      .getBalance()
      .call()
      .then((result) => {
        console.log(result);
        $balance.innerHTML = result;
      });
  };

  const getAccAddr = () => {
    simpleRegulator.methods
      .getAllClients()
      .call()
      .then((result) => {
        console.log(result);
        $acc.innerHTML = result;
      });
  };

  $depositData.addEventListener("submit", (e) => {
    e.preventDefault();
    const data = e.target.elements[0].value;
    simpleRegulator.methods
      .deposit(data)
      .send({ from: accounts[0] })
      .then(getData)
      .then(getAllClients);
  });

  $withdrawData.addEventListener("submit", (e) => {
    e.preventDefault();
    const data = e.target.elements[0].value;
    simpleRegulator.methods
      .withdraw(data)
      .send({ from: accounts[0] })
      .then(getData)
      .then(getAllClients);
  });
};

document.addEventListener("DOMContentLoaded", () => {
  initWeb3()
    .then((_web3) => {
      web3 = _web3;
      simpleRegulator = initContract();
      initApp();
    })
    .catch((e) => console.log(e.message));
});
