// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DiamondLedger {

    uint[] public diamonds;
    mapping (uint256 => uint256) public weightToFrequency;

    //this function imports the diamonds
    function importDiamonds(uint[] memory weights) public {

        for (uint i = 0; i < weights.length; i++) {
            diamonds.push(weights[i]);
            weightToFrequency[weights[i]]++;
        }


    }

    //this function returns the total number of available diamonds as per the weight
    function availableDiamonds(uint weight) public view returns(uint) {
        return weightToFrequency[weight];
    }

}