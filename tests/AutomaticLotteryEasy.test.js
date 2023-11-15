const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("Automatic Lottery System Easy", function(){
    let lottery, lottery_account1,lottery_account2,lottery_account3,lottery_account4;
    let owner, account1, account2, account3, account4;

    const ENTRANCE_FEE = ethers.utils.parseEther("0.1");
    beforeEach(async function(){
        const Lottery = await ethers.getContractFactory("AutoLottery");
        lottery = await Lottery.deploy();
        await lottery.deployed();
        [owner, account1, account2, account3, account4] = await ethers.getSigners();
        lottery_account1 = await lottery.connect(account1);
        lottery_account2 = await lottery.connect(account2);
        lottery_account3 = await lottery.connect(account3);
        lottery_account4 = await lottery.connect(account4);
    }) 

    describe("Enter", function(){
        it("should revert if enter value is not equal to the entrance fee", async function(){
            await expect(lottery.enter({value: 0})).to.be.reverted;
            await expect(lottery.enter({value: ethers.utils.parseEther("0.2")})).to.be.reverted;
        })
        it("should revert if sender is already in the raffle", async function(){
            await lottery.enter({value: ENTRANCE_FEE});
            await expect(lottery.enter({value: ENTRANCE_FEE})).to.be.reverted;
        })
        it("should enter participants correcty", async function(){
            await lottery.enter({value: ENTRANCE_FEE});
            await lottery_account1.enter({value: ENTRANCE_FEE});
            const participants = await lottery.viewParticipants();
            assert.equal(participants,([owner.address,account1.address,2]).toString())
        })
        it("should add Entrance fee to contract balance whenever someone enters", async function(){
            await lottery.enter({value: ENTRANCE_FEE});
            const oldContractBalance = Number(await lottery.getContractBalance());
            assert.equal(oldContractBalance,ENTRANCE_FEE);
            await lottery_account1.enter({value: ENTRANCE_FEE});
            const newContractBalance = Number(await lottery.getContractBalance());
            assert.equal(newContractBalance,oldContractBalance + Number(ENTRANCE_FEE));

        })
        it("should get a winner after 5 participants have entered", async function(){
            await lottery.enter({value: ENTRANCE_FEE});
            assert.equal((await lottery.viewPreviousWinner()).toString(),"0x0000000000000000000000000000000000000000");
            await lottery_account1.enter({value: ENTRANCE_FEE});
            await lottery_account2.enter({value: ENTRANCE_FEE});
            assert.equal((await lottery.viewPreviousWinner()).toString(),"0x0000000000000000000000000000000000000000");
            await lottery_account3.enter({value: ENTRANCE_FEE});
            await lottery_account4.enter({value: ENTRANCE_FEE});
            assert((await lottery.viewPreviousWinner()).toString() != "0x0000000000000000000000000000000000000000");
            
        })

    })

})