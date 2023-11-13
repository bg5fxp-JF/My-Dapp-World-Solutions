// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

error DidNotPayOut();

contract Lottery {

    uint256 private constant ENTRANCE_FEE = 0.1 ether;
    uint256 private constant NUM_PARTICIPANTS = 5;
    address[] private participants;
    address private prevWinner;
    mapping (address => bool) private alreadyExists;

    function enter() public payable {
        require(msg.value == ENTRANCE_FEE,"Not payed entrance fee");
        require(!alreadyExists[msg.sender],"Already in raffle");
        alreadyExists[msg.sender] = true;
        participants.push(msg.sender);
        if (participants.length + 1 > NUM_PARTICIPANTS) {
            prevWinner = participants[getWinner()];
            for(uint i = 0; i < participants.length; i++) {
                alreadyExists[participants[i]] = false;
            }
            participants = new address[](0);
            (bool success,) = payable(prevWinner).call{value:address(this).balance}("");

            if (!success) revert DidNotPayOut();
        }
    }
    function getWinner() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp))) % 5;
    }

    function viewParticipants() public view returns (address[] memory, uint) {
        return (participants, participants.length);
    }

    function viewPreviousWinner() public view returns (address) {
        return prevWinner;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}