// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract BuyingColors {

    mapping(string => uint256) public colourTocredit;
    uint256 public s_credits = 100;

    constructor() {
        colourTocredit["red"] = 40;
        colourTocredit["green"] = 30;
        colourTocredit["blue"] = 40;
    }

    // this function is used to buy the desired colour
    function buyColour(string memory colour, uint price) public {
        require(price <= s_credits, "Insufficent credit");
        require(price <= colourTocredit[colour], "Insufficent credit");
        colourTocredit[colour] -= price;
        s_credits -= price;
    }

    //this functions will return credit balance
    function credits() public view returns(uint n)   {
        return s_credits;
    }

}