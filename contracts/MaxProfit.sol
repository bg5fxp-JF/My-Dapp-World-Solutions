// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MaxProfit {

    //this function takes an array of prices and calculate maximum profit
    function maxProfit(uint256[] memory prices) public pure returns (uint256) {
        uint smallest = prices[0];
        uint largest = prices[0];
        unchecked {
            for (uint i; i < prices.length; i++) {
                if (prices[i] > largest) largest = prices[i];
                if (prices[i] < smallest) {
                    smallest = prices[i];
                    largest = 0;
                }

            }
        }
        return largest > smallest ? largest - smallest : 0;
    }

}