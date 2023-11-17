// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

error NotOwner();
error CannotBeMerchantAndScholar();
error AlreadyMerchant();
error NotAMerchant();
error NotAScholar();
error NotEnoughCredits();
error NotAllowed();


contract ScholarshipCreditContract {


    address public owner;
    mapping (address => bool) private isScholar;
    mapping (address => bool) private isMerchant;
    mapping (address => uint256) private totalCredits;


    constructor() {
        owner = msg.sender;
        totalCredits[owner] = 1000000;
    }

    modifier onlyOwner(){
        if(msg.sender != owner) revert NotOwner();
        _;
    }

    //This function assigns credits to student getting the scholarship
    function grantScholarship(address studentAddress, uint credits) public onlyOwner {
        if(studentAddress == msg.sender) revert CannotBeMerchantAndScholar();
        if(isMerchant[studentAddress]) revert CannotBeMerchantAndScholar();
        if(!isScholar[studentAddress]) isScholar[studentAddress] = true;
        if(totalCredits[msg.sender] < credits) revert NotEnoughCredits();
        totalCredits[msg.sender]-=credits;
        totalCredits[studentAddress]+=credits;
    }

    //This function is used to register a new merchant who can receive credits from students
    function registerMerchantAddress(address merchantAddress) public onlyOwner {
        if(merchantAddress == msg.sender) revert CannotBeMerchantAndScholar();
        if(isScholar[merchantAddress]) revert CannotBeMerchantAndScholar();
        if(isMerchant[merchantAddress]) revert AlreadyMerchant();
        isMerchant[merchantAddress] = true;
    }

    //This function is used to deregister an existing merchant
    function deregisterMerchantAddress(address merchantAddress) public onlyOwner{
        if(!isMerchant[merchantAddress]) revert NotAMerchant();
        totalCredits[msg.sender]+=totalCredits[merchantAddress];
        totalCredits[merchantAddress]-=totalCredits[merchantAddress];
        delete isMerchant[merchantAddress];
        delete totalCredits[merchantAddress];
    }

    //This function is used to revoke the scholarship of a student
    function revokeScholarship(address studentAddress) public onlyOwner{
        if(!isScholar[studentAddress]) revert NotAScholar();
        totalCredits[msg.sender]+=totalCredits[studentAddress];
        totalCredits[studentAddress]-=totalCredits[studentAddress];
        delete isScholar[studentAddress];
        delete totalCredits[studentAddress];
    }

    //Students can use this function to transfer credits only to registered merchants
    function spend(address merchantAddress, uint amount) public {
        if(!isScholar[msg.sender]) revert NotAScholar();
        if(!isMerchant[merchantAddress]) revert NotAMerchant();
        if(totalCredits[msg.sender] < amount) revert NotEnoughCredits();
        totalCredits[msg.sender]-=amount;
        totalCredits[merchantAddress]+=amount;
    }

    //This function is used to see the available credits assigned.
    function checkBalance() public view returns (uint) {
        if(!(isScholar[msg.sender] || isMerchant[msg.sender] || msg.sender == owner)) revert NotAllowed();
        return totalCredits[msg.sender];
    }
}