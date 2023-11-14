// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CompareStrings {

    function compare(string memory _s1, string memory _s2) public pure returns(bool) {
        return (keccak256(abi.encodePacked(_s1)) == keccak256(abi.encodePacked(_s2)));
    }
    
}