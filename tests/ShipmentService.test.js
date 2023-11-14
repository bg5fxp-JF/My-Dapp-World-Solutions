const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("ShipmentService", function(){
    let shipmentService, owner, otherAccount,anotherAccount;
    beforeEach( async function() {
        const ShipmentService = await ethers.getContractFactory("ShipmentService");
        shipmentService = await ShipmentService.deploy();
        await shipmentService.deployed();
        // console.log(`Shipment Service Deployed at ${shipmentService.address}`);
        [owner, otherAccount,anotherAccount] = await ethers.getSigners();
    })

    describe("shipWithPin", function(){
        
        it("reverts if not owner", async function(){
            const shipmentService_other = await shipmentService.connect(otherAccount);            
            await expect(shipmentService_other.shipWithPin(anotherAccount.address, 6634)).to.be.reverted;
        })
        it("reverts if owner is passed as customer", async function(){
        
            await expect(shipmentService.shipWithPin(owner.address, 6634)).to.be.reverted;
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
            const expectedOrder = "1,6634";
            assert.equal(order.toString(),expectedOrder);
            assert.equal((await shipmentService.checkStatus(anotherAccount.address)),"shipped");
        })
    })

    describe("acceptOrder", function(){
        let shipmentService_other;
        beforeEach(async function(){
            await shipmentService.shipWithPin(anotherAccount.address, 6634);
            shipmentService_other = await shipmentService.connect(anotherAccount);   
        })

        it("reverts if owner", async function(){     
            await expect(shipmentService.acceptOrder(6634)).to.be.reverted;
        })
        it("reverts if sender doesnt have order", async function(){    
            const shipmentService_another = await shipmentService.connect(otherAccount);
            await expect(shipmentService_another.acceptOrder(6634)).to.be.reverted;
        })
        it("reverts if pin is invalid", async function(){
            await expect(shipmentService_other.acceptOrder(6633)).to.be.reverted;
        })

        it("customer can successfully accept order", async function(){
            await shipmentService_other.acceptOrder(6634);
            const order = await shipmentService.getOrder(anotherAccount.address);
            const expectedOrder = "2,6634";
            assert.equal(order.toString(),expectedOrder);
            assert.equal((await shipmentService.checkStatus(anotherAccount.address)),"delivered");
        })

        it("should increase compelted deliveries", async function(){
            await shipmentService_other.acceptOrder(6634);
            const total = Number(await shipmentService_other.totalCompletedDeliveries(anotherAccount.address));
            const expectedTotal = 1;
            assert.equal(total,expectedTotal);
        })
      
        
    })

    describe("checkStatus", function(){
        it("should revert if person calling is not the address that was passed through", async function(){
            shipmentService_other = await shipmentService.connect(anotherAccount);   
            await expect(shipmentService_other.checkStatus(otherAccount.address)).to.be.reverted
        })

        it("should return correctly if no order was placed", async function(){
            shipmentService_other = await shipmentService.connect(anotherAccount);   
            assert.equal( (await shipmentService.checkStatus(anotherAccount.address)),"no orders placed");
            assert.equal( (await shipmentService_other.checkStatus(anotherAccount.address)),"no orders placed");
        })
    })


})