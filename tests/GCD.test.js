const {assert} = require("chai");
const {ethers} = require("hardhat");

describe("GCD test", function(){
    let gcd;

    beforeEach(async function(){
        const GCDTest = await ethers.getContractFactory("GCDTest");
        gcd = await GCDTest.deploy();
        await gcd.deployed();
        console.log(`GCDTest contract deplyed at: ${gcd.address}`);
    })

    it("should return correct value (1)", async function(){
        assert.equal((await gcd.gcd(2,3)).toString(),"1");
    })
    it("should return correct value (2)", async function(){
        assert.equal((await gcd.gcd(36,16)).toString(),"4");
    })
    it("should return correct value (3)", async function(){
        assert.equal((await gcd.gcd(56,16)).toString(),"8");
    })
    
})