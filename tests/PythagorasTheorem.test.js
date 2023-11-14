const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("Pythagoras Theorem", function(){
    let pt;
    beforeEach(async function(){
        const PT = await ethers.getContractFactory("RightAngledTriangle");
        pt = await PT.deploy();
        await pt.deployed();
        console.log(`Pythagoras Theorem Contract deployed at: ${pt.address}`);
    })

    it("should return correct value (1)", async function(){
        assert((await pt.check(3,4,5)));
    })
    it("should return correct value (2)", async function(){
        assert(!(await pt.check(10,10,20)));
    })
})