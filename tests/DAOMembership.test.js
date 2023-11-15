const {assert, expect} = require("chai");
const {ethers} = require("hardhat");

describe("DAO Membership", function(){
    let dao, dao_account1,dao_account2,dao_account3,dao_account4;
    let owner, account1, account2, account3, account4;

    beforeEach(async function(){
        const DAO = await ethers.getContractFactory("DAOMembership");
        dao = await DAO.deploy();
        await dao.deployed();
        [owner, account1, account2, account3, account4] = await ethers.getSigners();
        dao_account1 = await dao.connect(account1);
        dao_account2 = await dao.connect(account2);
        dao_account3 = await dao.connect(account3);
        dao_account4 = await dao.connect(account4);
    }) 

    describe("constructor", function(){
        it("should initialise correctly", async function(){
            assert.equal(Number(await dao.totalMembers()),1);
            assert(await dao.isMember(owner.address));
        })
    })

    describe("applyForEntry", function(){
        it("should revert if applicant is already a member", async function(){
            await expect(dao.applyForEntry()).to.be.reverted;
        })
        it("should revert if applicant is already an applicant", async function(){
            await dao_account1.applyForEntry();
            await expect(dao_account1.applyForEntry()).to.be.reverted;
        })
    })

    describe("approveEntry", function(){
        it("should revert sender is not a member", async function(){
            await expect(dao_account1.approveEntry(account2.address)).to.be.reverted;
        })
        it("should revert if account being voted for is already a member", async function(){
            await expect(dao.approveEntry(owner.address)).to.be.reverted;
        })
        it("should revert if address given is not an applicant", async function(){
            await expect(dao.approveEntry(account1.address)).to.be.reverted;
        })
        it("should revert if voter has already voted for the applicant", async function(){
            await dao_account1.applyForEntry();
            await dao.approveEntry(account1.address);
            await expect(dao.approveEntry(account1.address)).to.be.reverted;
        })
        it("should add applicant to member map if enough have voted", async function(){
            await dao_account1.applyForEntry();
            await dao.approveEntry(account1.address);
             assert(await dao.isMember(account1.address));
            assert(await dao.isMember(owner.address));
        })
    })

    describe("totalMembers", function(){
        it("should revert if not member", async function(){
            await expect(dao_account1.approveEntry(account2.address)).to.be.reverted;
        })
        it("should show total members", async function(){
            await dao_account1.applyForEntry();
            await dao.approveEntry(account1.address);
            assert.equal(Number(await dao.totalMembers()),2);
            
        })
    })
})