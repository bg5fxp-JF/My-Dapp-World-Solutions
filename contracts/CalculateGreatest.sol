// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Greatest {

    function Greater(uint256[] memory ard) public pure returns(uint256) {
        uint256 greatest;

        for (uint i = 0; i < ard.length; i++) {
            if (ard[i] > greatest) {
                greatest = ard[i];
            }
        }

        return greatest;
    }
    
}