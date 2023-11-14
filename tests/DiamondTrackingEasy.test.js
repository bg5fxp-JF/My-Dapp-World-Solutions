const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("Diamond tracking (Easy version)", function(){
    let dt;
    beforeEach(async function(){
        const DT = await ethers.getContractFactory("DiamondLedger");
        dt = await DT.deploy();
        await dt.deployed();
    })

    describe("availableDiamonds", function(){
        beforeEach(async function(){
            await dt.importDiamonds([4,8,3,3]);
        })
        it("should return correct value (1)", async function(){
            assert.equal(Number(await dt.availableDiamonds(1)),0);
        })
        it("should return correct value (2)", async function(){
            assert.equal(Number(await dt.availableDiamonds(4)),1);
        })
        it("should return correct value (1)", async function(){
            assert.equal(Number(await dt.availableDiamonds(3)),2);
        })
        it("should return correct value (2)", async function(){
            assert.equal(Number(await dt.availableDiamonds(8)),1);
        })
    })

})