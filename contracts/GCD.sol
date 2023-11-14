// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GCDTest {

    //this function calculates the GCD (Greatest Common Divisor)
    function gcd(uint a, uint b) public pure returns (uint) {

        while (a != 0 && b != 0) {
            if (a > b) {
                a = a % b;
            } else {
                b = b % a;
            }
        }

        return a == 0 ? b : a;
    }

}