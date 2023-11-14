const {assert} = require("chai");
const {ethers} = require("hardhat");

describe("Dinesh And Gambling", function(){
    let dag;

    beforeEach(async function(){
        const SecondLargest = await ethers.getContractFactory("SecondLargest");
        dag = await SecondLargest.deploy();
        await dag.deployed();
        console.log(`SecondLargest contract deplyed at: ${dag.address}`);
    })

    it("should return correct value (1)", async function(){
        assert.equal((await dag.findSecondLargest([1,2,3,4])).toString(),"3");
    })
    it("should return correct value (2)", async function(){
        assert.equal((await dag.findSecondLargest([-5,8,1,7])).toString(),"7");
    })
    
})