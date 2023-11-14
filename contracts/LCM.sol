// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract LCM {

    function gcd(uint a, uint b)internal pure returns (uint) {
        while (a != 0 && b!=0) {
            if (a > b) {
                a = a % b;
            } else {
                b = b % a;
            }
        }
        return a == 0 ? b : a;
    }

    //this function calculates the LCM
    function lcm(uint a, uint b) public pure returns (uint) {
        return a * b / gcd(a,b);
    }

}