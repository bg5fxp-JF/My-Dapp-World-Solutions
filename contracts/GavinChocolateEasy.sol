// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ChocolateShop  {

    uint public chocolates;

    modifier uintRequirement(uint n) {

        uint max = 2**255;
        require(n >= 0 && n <= max,"Not in range");
        _;

    }

    //this function allows gavin to buy n chocolates
    function buyChocolates(uint n) public uintRequirement(n) {
        chocolates += n;
    }

    //this function allows gavin to sell n chocolates
    function sellChocolates(uint n) public uintRequirement(n) {
        require(chocolates >= n, "not enough choc");
        chocolates -= n;
    }

    //this function returns total number of chocolates in bag
    function chocolatesInBag() public view returns(uint n) {
        return chocolates;
    }


}