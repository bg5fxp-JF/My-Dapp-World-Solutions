const {assert} = require("chai")
const {ethers} = require("hardhat")

describe("Gavin, Jack and abacus trick", function(){

    let abacus;

    beforeEach(async function(){
        const Abacus = await ethers.getContractFactory("Abacus");
        abacus = await Abacus.deploy();
        await abacus.deployed();
    })

    it("should add an integer to the sum", async function(){
        const og_sum = Number(await abacus.sumOfIntegers());
        const num = 5;
        await abacus.addInteger(num);
        const new_sum = Number((await abacus.sumOfIntegers()));
        assert.equal(new_sum,og_sum + num);
        await abacus.addInteger(num);
        assert.equal(Number((await abacus.sumOfIntegers())),new_sum + num);
    })
    it("should subtract an integer from the sum", async function(){
        const og_sum = Number(await abacus.sumOfIntegers());
        const num = 5;
        await abacus.addInteger(num);
        const new_sum = Number((await abacus.sumOfIntegers()));
        assert.equal(new_sum,og_sum + num);
        await abacus.addInteger(-num);
        assert.equal(Number((await abacus.sumOfIntegers())),new_sum - num);
    })
})

