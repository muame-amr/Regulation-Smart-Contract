// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract Regulation {
    
    /**
     * Variables
     */
    
    struct client_account {
        int id;
        address addr;
        uint balance;
    }
    
    struct involve {
        address addr;
        uint amount;
    }
    
    client_account[] clients;
    involve[] involved;
    address[] allClients;
    int clientCounter;
    bool susTX;
    uint maxBalance;
    uint threshold;
    address payable regulator;
    
    constructor() public {
        clientCounter = 0;
        maxBalance = 50 ether;
        susTX = false;
    }
    
    /**
     * Events
     */
     event warning(string);
     event allSuspects(address, uint);
     event suspectedClients(address);
    
    /**
     * Modifier
     */
    
    modifier onlyRegulator() {
        require(msg.sender == regulator, "Only regulator can call!");
        _;
    }
    
    modifier onlyClients() {
        bool isClient = false;
        for(uint i = 0; i < clients.length; ++i) {
            if(clients[i].addr == msg.sender) {
                isClient = true;
                break;
            }
        }
        require(isClient, "Only clients can call!");
        _;
    }
    
    /**
     * Utilities
     */
    
    /**
     * Contract Functions (only can be access Regulator)
     */
    
    function setRegulator(address _regulatorAddress) public returns (string memory) {
        regulator = payable(_regulatorAddress);
        return "";
    }
    
    function setThreshold (uint _amount) public onlyRegulator returns(string memory){
        threshold = _amount * 1 ether;
        return "";
    }
    
    function getAlert () onlyRegulator public {
        if(susTX == true) {
            emit warning("Alert: Huge amount transaction !");
            for(uint i = 0; i < involved.length; ++i) {
                emit allSuspects(involved[i].addr, involved[i].amount);
            }
        } else {
            emit warning("Message: No suspicious transaction !");
        }
        if(address(this).balance > maxBalance) {
            emit warning("Alert: Suspected crypto laundering !");
            for(uint i = 0; i < involved.length; ++i) {
                emit suspectedClients(allClients[i]);
            }
        } else {
            emit warning("Message: No suspicious laundering !");
        }
    }
    
    /**
     * Contract Functions
     */
    
    function joinAsClient() public payable returns (string memory) {
        clients.push(client_account(clientCounter++, msg.sender, address(msg.sender).balance));
        return "";
    }
    
    function deposit() public payable onlyClients {
        payable(address(this)).transfer(msg.value);
        allClients.push(msg.sender);
        if(msg.value > threshold) {
            involved.push(involve(msg.sender, msg.value));
            susTX = true;
        }
    }
    
    function withdraw(uint _amount) public payable onlyClients {
        msg.sender.transfer(_amount * 1 ether);
        allClients.push(msg.sender);
        if(_amount > threshold) {
            involved.push(involve(msg.sender, _amount));
            susTX = true;
        }
    }
    
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    /**
     * Fallback function for the contract to receive ether
     */
    
    receive () external payable {}
}