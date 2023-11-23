// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ChocolateShop  {

    uint public chocolates;
    int[] private transactions;

    modifier uintRequirement(uint n) {
        uint max = 2**255;
        require(n >= 0 && n <= max,"Not in range");
        _;
    }

    //this function allows gavin to buy n chocolates
    function buyChocolates(uint n) public uintRequirement(n) {
        chocolates += n;
        transactions.push(int(n));
    }

    //this function allows gavin to sell n chocolates
    function sellChocolates(uint n) public uintRequirement(n) {
        require(chocolates >= n, "not enough choc");
        chocolates -= n;
        transactions.push(-int(n));
    }

    //this function returns total number of chocolates in bag
    function chocolatesInBag() public view returns(uint n) {
        return chocolates;
    }

        // this function returns the nth transaction
    function showTransaction(uint n) public view returns(int) {
        return transactions[n-1];
    }

    //this function returns the total number of transactions
    function numberOfTransactions() public view returns(uint) {
        return transactions.length;
    }


}