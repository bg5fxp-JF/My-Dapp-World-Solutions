// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SmartWallet {

    address owner;
    uint funds;
    mapping(address => bool) access;
    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier onlyAccess(){
        require(msg.sender == owner || access[msg.sender]);
        _;
    }

    //this function allows adding funds to wallet
    function addFunds(uint amount) public {
        require(10000 >= (funds + amount));
        require(access[msg.sender]);
        funds += amount;
    }

    //this function allows spending an amount to the account that has been granted access by Gavin
    function spendFunds(uint amount) public onlyAccess{
        require(funds - amount >= 0);
        funds -= amount;
    }

    //this function grants access to an account and can only be accessed by Gavin
    function addAccess(address x) public onlyOwner{
        access[x] = true;
    }

    //this function revokes access to an account and can only be accessed by Gavin
    function revokeAccess(address x) public onlyOwner{
        access[x] = false;
    }

    //this function returns the current balance of the wallet
    function viewBalance() public view onlyAccess returns(uint) {
        return funds;
    }
}