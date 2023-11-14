// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CheckEven {

    function Checkeven(int num) public pure returns(bool) {
        return (num % 2 == 0);
    }
    
}