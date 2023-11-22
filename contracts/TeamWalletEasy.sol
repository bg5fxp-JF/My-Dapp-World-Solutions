// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error NotOwner();
error AlreadyBeenSet();
error InvalidParam();
error NotMember();
error NotEnoughCredits();
error AlreadyVoted();
error AlreadyApproved();
error AlreadyRejected();
error TransactionDoesNotExist();

contract TeamWallet {

    struct Transaction {
        uint256 amount;
        uint256 approvals;
        uint256 rejections;
        string status;
    }


    address private immutable i_owner;
    bool private hasBeenSet;
    uint256 private walletCredits;
    uint256 private numMembers;
    uint256 private transactionId;
    mapping (address => bool) isMember;
    mapping (uint256 => Transaction) transactionIdToTransaction;
    mapping (uint256 => mapping(address => bool)) hasVoted;

    constructor() {
        i_owner = msg.sender;
        hasBeenSet = false;
        transactionId = 1;
    }

    modifier onlyMember {
        if (!isMember[msg.sender]) revert NotMember();
        _;
    }


    //For setting up the wallet
    function setWallet(address[] memory members, uint256 _credits) public {
        if(hasBeenSet) revert AlreadyBeenSet();
        if(msg.sender != i_owner) revert NotOwner();
        if(members.length < 1 || _credits < 1) revert InvalidParam();
        
        for (uint i; i < members.length; i++) {
            if (members[i] == i_owner) revert();
            isMember[members[i]] = true;
        } 
        numMembers = members.length;
        walletCredits = _credits;
        hasBeenSet = true;
    }

    //For spending amount from the wallet
    function spend(uint256 _amount) public onlyMember {
        if(_amount < 1) revert NotEnoughCredits();
        Transaction memory newTransaction = Transaction({amount:_amount,approvals:1,rejections:0,status:"pending"});
        if (_amount > credits()) {
            newTransaction.status = "failed";
        } else {
            if (numMembers == 1) { 
                newTransaction.status = "debited";
                walletCredits-= _amount;
            }
        }

        hasVoted[transactionId][msg.sender] = true;
        transactionIdToTransaction[transactionId] = newTransaction;
        transactionId++;
    }

    //For approving a transaction request
    function approve(uint256 n) public onlyMember {
        if(hasVoted[n][msg.sender]) revert AlreadyVoted();
        if(bytes(transactionIdToTransaction[n].status).length == 0) revert TransactionDoesNotExist();
        if(keccak256(bytes(transactionIdToTransaction[n].status)) == keccak256((bytes("debited")))) revert AlreadyApproved();
        if(keccak256(bytes(transactionIdToTransaction[n].status)) == keccak256((bytes("failed")))) revert AlreadyRejected();
        transactionIdToTransaction[n].approvals++;
        hasVoted[n][msg.sender] = true;
        if (transactionIdToTransaction[n].approvals > (numMembers * 7) / 10) {
            transactionIdToTransaction[n].status = "debited";
            walletCredits-=transactionIdToTransaction[n].amount;
        }
    }   

    //For rejecting a transaction request
    function reject(uint256 n) public onlyMember {
        if(hasVoted[n][msg.sender]) revert AlreadyVoted();
        if(bytes(transactionIdToTransaction[n].status).length == 0) revert TransactionDoesNotExist();
        if(keccak256(bytes(transactionIdToTransaction[n].status)) == keccak256((bytes("debited")))) revert AlreadyApproved();
        if(keccak256(bytes(transactionIdToTransaction[n].status)) == keccak256((bytes("failed")))) revert AlreadyRejected();
        transactionIdToTransaction[n].rejections++;
        hasVoted[n][msg.sender] = true;
        if (transactionIdToTransaction[n].rejections > (numMembers * 3) / 10) {
            transactionIdToTransaction[n].status = "failed";
        }
    }

    //For checking remaing credits in the wallet
    function credits() public view onlyMember returns (uint256) {
        return walletCredits;
    }

    //For checking nth transaction status
    function viewTransaction(uint256 n) public view onlyMember returns (uint amount,string memory status){
        if(bytes(transactionIdToTransaction[n].status).length == 0) revert TransactionDoesNotExist();
        amount = transactionIdToTransaction[n].amount;
        status = transactionIdToTransaction[n].status;
    }

}