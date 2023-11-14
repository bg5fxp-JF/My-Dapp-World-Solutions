const {assert} = require("chai");
const {ethers} = require("hardhat");

describe("LCM", function(){
    let lcm;
    beforeEach(async function(){
        const LCM = await ethers.getContractFactory("LCM");
        lcm = await LCM.deploy();
        await lcm.deployed();

        console.log(`LCM Contract deplyed at ${lcm.address}`);
    })

    it("should return correct values (1)", async function(){
        assert.equal((await lcm.lcm(8,10)).toString(),"40");
    })
    it("should return correct values (2)", async function(){
        assert.equal((await lcm.lcm(12,18)).toString(),"36");
    })
})