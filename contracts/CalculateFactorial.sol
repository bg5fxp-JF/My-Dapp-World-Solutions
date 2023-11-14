// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract CalculateFactorial {

    // this function calculates the factorial of a give number
    function Factorial(uint _a) public pure returns(uint) {
        uint factorial = 1;

        for( uint i=1; i<=_a ; i++ ){
    
            factorial = factorial * i;
            
        }

        return factorial;
    }

}