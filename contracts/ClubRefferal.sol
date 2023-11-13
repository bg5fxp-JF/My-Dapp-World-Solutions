// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

error AlreadyMember();
error NotRightAmount();
error ReffererNotValid();
error PaymentNotSuccessful();

contract MyContract {

    uint256 private constant ENTRANCE_FEE = 1 ether;

    address[] private members;
    mapping(address => bool) private alreadyMember;

    function join() public payable {
        if (alreadyMember[msg.sender]) revert AlreadyMember();
        if (msg.value != ENTRANCE_FEE) revert NotRightAmount();
        members.push(msg.sender);
        alreadyMember[msg.sender] = true;
    }

    function join_referrer(address refferer) public payable {
        if (alreadyMember[msg.sender]) revert AlreadyMember();
        if (!alreadyMember[refferer]) revert ReffererNotValid();
        if (msg.value != ENTRANCE_FEE) revert NotRightAmount();
        
        members.push(msg.sender);
        alreadyMember[msg.sender] = true;

        (bool success,) = payable(refferer).call{value: ENTRANCE_FEE / 10}("");
        if(!success) revert PaymentNotSuccessful();

    }

    function get_members() public view returns(address[] memory) {
        return members;
    }
    
}