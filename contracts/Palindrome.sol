// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PalindromeChecker {


    
    //To check if a given string is palindrome or not
    function isPalindrome(string calldata _s) pure public returns (bool){
        if (bytes(_s).length == 0) return true;

      
        uint[] memory p = new uint[](bytes(_s).length);
        uint y = 0;

        unchecked {

            for(uint i = 0; i < bytes(_s).length; ++i) {
                uint x = uint8(bytes(_s)[i]);
                if(x < 0x61) x = x + 0x20;
                if(x >= 0x61 && x <= 0x7a) 
                    p[y++] = x;
            } 

            uint j = y;
            for(uint i; i < y; ++i) {
                --j;
                if(p[i] != p[j]) return false;
            } 
               
        }

        return true;
        
    }

}
