// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error NotOwner();
error NotEnoughFundsToEnter();
error AlreadyParticipating();
error NotParticipant();
error UnsuccessfulPayout();

contract LotteryPool {

    uint8 private constant MAX_PARTICIPANTS = 5;
    address private immutable owner;
    address[] private s_participants;
    address private s_prevWinner;
    uint256 private s_gavinsEarnings;
    mapping (address => uint) timesWon;
    mapping (address => bool) isParticipant;

    constructor() {
        owner = msg.sender;
    }

    // For participants to enter the pool
    function enter() public payable {
        if(msg.sender == owner) revert NotParticipant();
        if (isParticipant[msg.sender]) revert AlreadyParticipating();
        uint256 entranceFee = 0.1 ether + timesWon[msg.sender]*0.01 ether;
        if (msg.value != entranceFee) revert NotEnoughFundsToEnter();
        (bool success,) = payable(owner).call{value:entranceFee/10}("");
        if(!success) revert UnsuccessfulPayout();
        
        s_gavinsEarnings += entranceFee/10;

        isParticipant[msg.sender] = true;
        s_participants.push(msg.sender);

        if(s_participants.length == MAX_PARTICIPANTS) {
            s_prevWinner = s_participants[getWinner()];
            timesWon[s_prevWinner]++;
            for(uint i = 0; i < s_participants.length; i++) {
                delete isParticipant[s_participants[i]];
            }
            s_participants = new address[](0);
            (bool success1,) = payable(s_prevWinner).call{value:address(this).balance}("");
            if (!success1) revert UnsuccessfulPayout();
        }
    }

    function getWinner() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp))) % 5;
    }

    // For participants to withdraw from the pool
    function withdraw() public {
        if (!isParticipant[msg.sender] || msg.sender == owner) revert NotParticipant();
        uint256 entranceFee = 0.1 ether + timesWon[msg.sender]*0.01 ether;
        (bool success,) = payable(msg.sender).call{value:entranceFee - (entranceFee/10)}("");
        if (!success) revert UnsuccessfulPayout();
        
        delete isParticipant[msg.sender];
        for (uint i; i < s_participants.length; i++){
            if(s_participants[i] == msg.sender) {
                address temp = s_participants[i];
                s_participants[i] = s_participants[s_participants.length - 1];
                s_participants[s_participants.length - 1] = temp;
                s_participants.pop();
                break;
            }
        }
    }

    // To view participants in current pool
   function viewParticipants() public view returns (address[] memory, uint) {
        return (s_participants, s_participants.length);
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
        return s_prevWinner;
    }

    // To view the amount earned by Gavin
    function viewEarnings() public view returns (uint256) {
        if(msg.sender != owner) revert NotOwner();
        return s_gavinsEarnings;
    }

    // To view the amount in the pool
    function viewPoolBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
