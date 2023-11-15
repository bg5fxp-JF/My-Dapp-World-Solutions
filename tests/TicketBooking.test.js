const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("Bus Ticket Booking", function(){
    let ticketB, ticketB_account1,ticketB_account2,ticketB_account3,ticketB_account4;
    let owner, account1, account2, account3, account4;

    beforeEach(async function(){
        const TB = await ethers.getContractFactory("TicketBooking");
        ticketB = await TB.deploy();
        await ticketB.deployed();
        [owner, account1, account2, account3, account4] = await ethers.getSigners();
        ticketB_account1 = await ticketB.connect(account1);
        ticketB_account2 = await ticketB.connect(account2);
        ticketB_account3 = await ticketB.connect(account3);
        ticketB_account4 = await ticketB.connect(account4);
    }) 

    describe("bookSeats", function(){
        it("should revert parameter given is too large or too small", async function(){
            await expect(ticketB.bookSeats([])).to.be.reverted;
            await expect(ticketB.bookSeats([1,2,3,4,5])).to.be.reverted;
        })
        it("should revert parameter given repeats seats", async function(){
            await expect(ticketB.bookSeats([1,2,3,3])).to.be.reverted;
        })
        it("should revert if sender has booked max amount of tickets", async function(){
            await ticketB.bookSeats([5,6,7,8]);
            await expect(ticketB.bookSeats([1,2,3,4])).to.be.reverted;
        })
        it("should revert if seat is already booked", async function(){
            await ticketB.bookSeats([5,6,7,8]);
            await expect(ticketB_account1.bookSeats([5])).to.be.reverted;
        })
        it("should remove booked seats from available seats array", async function(){
            await ticketB.bookSeats([1,2,3]);
            assert.equal((await ticketB.showAvailableSeats()),[4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20].toString())
        })

        it("should show tickets correspoinding to sender after being booked", async function(){
            await ticketB.bookSeats([1,2,3]);
            await ticketB_account1.bookSeats([4,5]);
            assert.equal((await ticketB.myTickets()),[1,2,3].toString());
            assert.equal((await ticketB_account1.myTickets()),[4,5].toString());
        } )
        it("should allow sender to book at separate times and still store previous tickets", async function(){
            await ticketB.bookSeats([1,2,3]);
            assert.equal((await ticketB.myTickets()),[1,2,3].toString());
            await ticketB.bookSeats([4]);
            assert.equal((await ticketB.myTickets()),[1,2,3,4].toString());
        } )
    })

    describe("checkAvailability",  function(){
        it("should return correct value", async function(){
            await ticketB.bookSeats([1,2,3]);
            assert((await ticketB.checkAvailability(4)));
            assert(!(await ticketB.checkAvailability(3)));
        })
    })
})