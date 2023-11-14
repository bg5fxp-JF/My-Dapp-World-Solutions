// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RightAngledTriangle {
    //To check if a triangle with side lenghts a,b,c is a right angled triangle
    function check(uint a, uint b, uint c) public pure returns (bool) {
        if (a == 0 || b == 0 || c == 0) return false;
        return (a ** 2 + b ** 2 == c ** 2);
    }
}
