// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Fibonacci {  
    function fibonacci(uint n) public pure returns (uint) { 
        if(n<=1){ 
            return n;
        } else { 
            uint a=0; 
            uint b=1; 
            uint result; 
            for(uint i=2;i<=n;i++) { 
                result=a+b; a=b; b=result; 
            } 
        
            return result; 
        
        } 
    } 

}
