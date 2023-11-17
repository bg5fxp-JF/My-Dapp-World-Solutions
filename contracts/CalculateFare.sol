// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CalculateFare {

    uint256 public finalfare;

    function calculatefare(uint256 station1, uint256 station2) public returns(uint256) {
        // a & b = 2
        // b & c = 5
        // c & d = 11
        // d & e = 23
        // uint8[5] memory ar = [0,2,3,8,15];
        uint totalDistance = 0;
        uint currentDistance = 2; // Initial distance between A & B

        if (station1 == station2) return 0;
        
        if (station1 > station2) {
            uint temp = station2;
            station2 = station1;
            station1 = temp;
        }

        unchecked {
            for(uint i = station1; i < station2; i++) {
                totalDistance += currentDistance;
                currentDistance = 2 * currentDistance + 1;
            }
        }
        
        
        finalfare = totalDistance;

        return finalfare;

    }
    
}