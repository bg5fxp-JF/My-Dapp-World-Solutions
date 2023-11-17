// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MagicArray {

    //this function outputs value of arr[ind] after 'hrs' number of hours
    function findValue(int[] memory arr, uint ind, uint hrs) public pure returns (int){
        return arr[ind] * int(hrs);
    }

}