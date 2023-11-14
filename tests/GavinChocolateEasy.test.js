const {assert,expect} = require("chai")
const {ethers} = require("hardhat")

describe("Gavin and the chocolate shop (Easy version)", function(){

    let cs;

    beforeEach(async function(){
        const ChocolateShop = await ethers.getContractFactory("ChocolateShop");
        cs = await ChocolateShop.deploy();
        await cs.deployed();

    })

    describe("buyChocolates", function(){

        it("should revert if number is out of bounds", async function(){
            const oob_num1 = -1;
            const oob_num2 = Math.pow(2,256) ;
            await expect(cs.buyChocolates(oob_num1)).to.be.reverted;
            await expect(cs.buyChocolates(oob_num2)).to.be.reverted;
        })

        it("should increase count in chocolates bag", async function(){
            const og_chocs = Number(await cs.chocolatesInBag());
            const num = 5;
            await cs.buyChocolates(num);
            const new_chocs = Number((await cs.chocolatesInBag()));
            assert.equal(new_chocs,og_chocs + num);
            await cs.buyChocolates(num);
            assert.equal(Number((await cs.chocolatesInBag())),new_chocs + num);
        })
    })

    describe("sellChocolates", function(){
        it("should revert if number is out of bounds", async function(){
            const oob_num1 = -1;
            const oob_num2 = Math.pow(2,256) ;
            await expect(cs.sellChocolates(oob_num1)).to.be.reverted;
            await expect(cs.sellChocolates(oob_num2)).to.be.reverted;
        })
        it("should revert if there's not enough chocs to sell", async function(){
            await expect(cs.sellChocolates(5)).to.be.reverted;
        })

        it("should sell chocs and subtract from the total chocs in bag", async function(){
            const og_chocs = Number(await cs.chocolatesInBag());
            const num = 5;
            await cs.buyChocolates(num);
            const new_chocs = Number((await cs.chocolatesInBag()));
            assert.equal(new_chocs,og_chocs + num);
            await cs.sellChocolates(num);
            assert.equal(Number((await cs.chocolatesInBag())),new_chocs - num);
        })
    })

})

