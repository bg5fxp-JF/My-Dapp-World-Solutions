const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("ShipmentService", function(){
    let shipmentService;
    beforeEach( async function() {
        const ShipmentService = await ethers.getContractFactory("ShipmentService");
        shipmentService = await ShipmentService.deploy();
        await shipmentService.deployed();

  
        console.log(`Shipment Service Deployed at ${shipmentService.address}`);
    })

    describe("shipWithPin", function(){
        let owner, otherAccount,anotherAccount;
        beforeEach(async function(){
            [owner, otherAccount,anotherAccount] = await ethers.getSigners();
        })

        it("reverts if not owner", async function(){
            console.log(otherAccount);
            const shipmentService_other = await shipmentService.connect(otherAccount);            
            await expect(shipmentService_other.shipWithPin(anotherAccount.address, 6634)).to.be.reverted;
        })
        it("reverts if pin is invalid", async function(){
            await expect(shipmentService.shipWithPin(anotherAccount.address, 66314)).to.be.reverted;
            await expect(shipmentService.shipWithPin(anotherAccount.address, 999)).to.be.reverted;
            await expect(shipmentService.shipWithPin(anotherAccount.address, 1)).to.be.reverted;
        })

        it("reverts if order by customer has already been placed", async function(){
            await shipmentService.shipWithPin(anotherAccount.address, 6634);
            await expect(shipmentService.shipWithPin(anotherAccount.address, 6644)).to.be.reverted;
        })

        it("successfully ships order to customer", async function(){
            await shipmentService.shipWithPin(anotherAccount.address, 6634);
            const order = await shipmentService.getOrder(anotherAccount.address);

            const expectedOrder = "0,6634";

            assert.equal(order.toString(),expectedOrder);
        })
    })


})