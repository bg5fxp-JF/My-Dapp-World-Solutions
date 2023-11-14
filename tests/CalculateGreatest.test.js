const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("Pythagoras Theorem", function(){
    let greatest;
    beforeEach(async function(){
        const Greatest = await ethers.getContractFactory("Greatest");
        greatest = await Greatest.deploy();
        await greatest.deployed();
    })

    it("should return correct value (1)", async function(){
        assert.equal(Number(await greatest.Greater([23, 56, 23, 46, 76, 8])),76);
    })
    it("should return correct value (2)", async function(){
        assert.equal(Number(await greatest.Greater([134, 567, 22])),567);
    })
})