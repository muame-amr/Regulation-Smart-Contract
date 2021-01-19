// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract SimpleRegulator {
    uint threshold;
    uint balance;
    uint fundThreshold;
    bool exceedLim;
    bool moneyLaund;
    address[] clientsAddr;
    
    constructor() public {
        balance = 15;
        exceedLim = false;
        moneyLaund = false;
        fundThreshold = 50;
    }
    
    struct Client {
        address addr;
        uint amount;
    }
    
    Client[] withdraw_clients;
    Client[] deposit_clients;
    Client[] suspicious;
    
    function getAlert() public view returns(string memory) {
        if (exceedLim || moneyLaund) {
            return "Suspicious Transaction & Money Laundering";
        } else {
            return "No suspicious transaction";
        }
    }
    
    function getBalance() public view returns(uint) {
        return balance;
    }
    
    function getAllClients() public view returns(address[] memory) {
        return clientsAddr;
    }
    
    function setThreshold(uint _threshold) public {
        threshold = _threshold;
    }
    
    function deposit(uint _amount) public {
        uint ethc = _amount;
        Client memory depositor = Client(msg.sender, ethc);
        bool exist = true;
       for(uint i = 0; i < clientsAddr.length; ++i) {
            if(clientsAddr[i] == msg.sender) {
                exist = false;
                break;
            }
        }
        if(exist) {
            clientsAddr.push(msg.sender);
        }
        if(ethc > threshold) {
            exceedLim = true;
            suspicious.push(depositor);
        }
        balance += ethc;
        if(balance > 50) {
            moneyLaund = true;
        }
        deposit_clients.push(depositor);
    }
    
    function withdraw(uint _amount) public{
        uint ethc = _amount;
        Client memory withdrawer = Client(msg.sender, ethc);
        bool exist = true;
        for(uint i = 0; i < clientsAddr.length; ++i) {
            if(clientsAddr[i] == msg.sender) {
                exist = false;
                break;
            }
        }
        if(exist) {
            clientsAddr.push(msg.sender);
        }
        if(ethc > threshold) {
            exceedLim = true;
            suspicious.push(withdrawer);
        }
        balance -= ethc;
        withdraw_clients.push(withdrawer);
    }
}