const {assert} = require("chai");
const {ethers} = require("hardhat");

describe("Fibonacci", function(){

    let fib;
    beforeEach(async function(){
        const Fibonacci = await ethers.getContractFactory("Fibonacci");
        fib = await Fibonacci.deploy();
        await fib.deployed();
        console.log(`Fibonacci Contract deployed at: ${fib.address}`);
    })

    it("should return correct value (1)",async function(){
        assert.equal((await fib.fibonacci(0)).toString(),"0");
    })
    it("should return correct value (2)",async function(){
        
        assert.equal( (await fib.fibonacci(1)).toString(),"1");
    })
    it("should return correct value (3)",async function(){
        assert.equal((await fib.fibonacci(6)).toString(),"8");
    })
})
