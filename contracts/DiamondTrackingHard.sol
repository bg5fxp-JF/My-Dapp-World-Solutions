// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DiamondLedger {

    uint[] public diamonds;

    //this function imports the diamonds
    function importDiamonds(uint[] memory weights) public {

        for (uint i = 0; i < weights.length; i++) {
            diamonds.push(weights[i]);
        }


    }

    //this function returns the total number of available diamonds as per the weight
    function availableDiamonds(uint weight, uint allowance) public view returns(uint) {
        uint count;

        for (uint i; i < diamonds.length; i++) {
            if (diamonds[i] >= weight - allowance && diamonds[i] <= weight + allowance) {
                count++;
            }
        }
        return count;
    }

}