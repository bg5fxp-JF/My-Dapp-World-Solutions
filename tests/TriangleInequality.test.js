const { assert,expect } = require("chai");
const { ethers } = require("hardhat");

describe("TriangleInequality", function() {
    describe("check", function() {
        let  ti;
        beforeEach(async function() {
            const TriangleInequality = await ethers.getContractFactory("TriangleInequality");
            ti = await TriangleInequality.deploy();
            await ti.deployed();
            console.log("TriangleInequality deployed at:" + ti.address);
        })

        it("should return true with correct values", async function () {
            assert(await ti.check(7,5,10));
        });
        it("should return false with incorrect values", async function () {
            assert(await ti.check(1,1,6) == false);
        });
    })
})