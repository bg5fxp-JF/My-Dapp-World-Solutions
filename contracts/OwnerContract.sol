// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract OwnerContract {
    uint256 private num;
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function get_owner() public view returns(address) {
        return owner;
    }

    function change_owner(address newOwner) public  {
        require(msg.sender == owner, "NotOwner");
        owner = newOwner;
    }

    function store(uint256 _num) public {
        require(msg.sender == owner, "NotOwner");
        num = _num;
    }

    function retrieve() public  view returns(uint) {
        return num;
    }
    
}