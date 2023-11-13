// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TriangleInequality {
    //To check if a triangle is possible with lengths a,b and c
    function check(uint a, uint b, uint c) public pure returns (bool) {
        if (a + b > c) {
            if (b + c > a) {
                if (c + a > b) {
                    return true;
                }
            }
        } 

        return false;
    }
}