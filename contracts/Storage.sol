// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Storage {

    int private a;

    //this function stores an integer
    function store(int _a) public {
        a = _a;
    }

    //this function returns the stored integer
    function retrieve() public view returns(int) {
        return a;
    }

}