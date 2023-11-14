// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SecondLargest {

    //this function outputs the second largest integer in the array
    function findSecondLargest(int[] memory arr) public pure returns (int) {
        int secL = -2**255;
        int firL = (-2**255) + 1;
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] > firL) {
                secL = firL;
                firL = arr[i];
            } else {

                if (arr[i] > secL) {
                    secL = arr[i];
                }
            }


        }

        return secL;
    }

}