const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("Jared and Maths Homework", function(){
    let jamhw;
    const oob_num1 = -1;
    const oob_num2 = Math.pow(2,253);
    
    beforeEach(async function(){
        const CalculateArea = await ethers.getContractFactory("CalculateArea");
        jamhw = await CalculateArea.deploy();
        await jamhw.deployed();

        console.log(`Jared and Maths Homework Contract deplyed at ${jamhw.address}`);
    })

    describe("squareArea", function(){
        it("should revert if input is out of bounds", async function(){
            await expect(jamhw.squareArea(oob_num1)).to.be.reverted;
            await expect(jamhw.squareArea(oob_num2)).to.be.reverted;
        })

        it("should return the correct value", async function(){
            assert.equal((await jamhw.squareArea(5)).toString(),"25");
        })
    })
    describe("rectangleArea", function(){
        it("should revert if input is out of bounds", async function(){
            await expect(jamhw.rectangleArea(oob_num1,5)).to.be.reverted;
            await expect(jamhw.rectangleArea(oob_num2,5)).to.be.reverted;
            await expect(jamhw.rectangleArea(5,oob_num1)).to.be.reverted;
            await expect(jamhw.rectangleArea(5,oob_num2)).to.be.reverted;
        })

        it("should return the correct value", async function(){
            assert.equal((await jamhw.rectangleArea(2,3)).toString(),"6");
        })
    })

})