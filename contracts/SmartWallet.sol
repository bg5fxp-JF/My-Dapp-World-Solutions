// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

error NotOwner();
error NotApprovedAddress();

contract SmartWallet {

    address private immutable owner;
    mapping (address => bool) addressToAllowed;

    uint256 walletBalance;

    modifier onlyOwner() {
        if (owner != msg.sender) revert NotOwner();
        _;
    }

    modifier onlyApproved() {
        if (!addressToAllowed[msg.sender] || owner != msg.sender) revert NotApprovedAddress();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    //this function allows adding funds to wallet
    function addFunds(uint amount) public onlyApproved {
        require(walletBalance + amount < 10001);
        walletBalance += amount;
    }

    //this function allows spending an amount to the account that has been granted access by Gavin
    function spendFunds(uint amount) public onlyApproved {
        require(walletBalance - amount >= 0);
        walletBalance -= amount;
    }

    //this function grants access to an account and can only be accessed by Gavin
    function addAccess(address x) public onlyOwner {
        addressToAllowed[x] = true;
    }

    //this function revokes access to an account and can only be accessed by Gavin
    function revokeAccess(address x) public onlyOwner {
         addressToAllowed[x] = false;
    }

    //this function returns the current balance of the wallet
    function viewBalance() public view onlyApproved returns(uint) {
        return walletBalance;
    }

}