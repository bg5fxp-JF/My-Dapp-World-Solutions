// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

error NotOwner();
error CannotBeMerchantAndScholar();
error CannotBeOwnerAndScholar();
error AlreadyMerchant();
error NotAMerchant();
error NotAScholar();
error NotEnoughCredits();
error NotAllowed();
error InvalidCategory();


contract ScholarshipCreditContract {

    struct Scholarship {
        uint256 id;
        uint256 all;
        uint256 meal;
        uint256 academics;
        uint256 sports;
    }
    struct Merchant {
        uint256 id;
        string category;
        uint credits;
    }

    address public owner;
    uint256 private scholarId;
    uint256 private merchantId;
    uint256 private totalCredits;
    mapping (address => Scholarship) private addressToScholarship;
    mapping (address => Merchant) private addressToMerchant;
    // mapping (address => uint256) private totalCredits;

    constructor() {
        owner = msg.sender;
        totalCredits = 1000000;
        scholarId = 1;
        merchantId = 1;
    }

    modifier onlyOwner(){
        if(msg.sender != owner) revert NotOwner();
        _;
    }

    //This function assigns credits to student getting the scholarship
    function grantScholarship(address studentAddress, uint credits, string memory category) public onlyOwner {
        if (!(keccak256(bytes(category)) == keccak256(bytes("all")) 
        || keccak256(bytes(category)) == keccak256(bytes("meal"))
        || keccak256(bytes(category)) == keccak256(bytes("academics"))
        || keccak256(bytes(category)) == keccak256(bytes("sports"))
        )) revert InvalidCategory();
        if(studentAddress == msg.sender) revert CannotBeOwnerAndScholar();
        if(addressToMerchant[studentAddress].id > 0) revert CannotBeMerchantAndScholar();
        if(totalCredits < credits) revert NotEnoughCredits();
        if(addressToScholarship[studentAddress].id < 1) {
            Scholarship memory newScholar = Scholarship({id:scholarId,all:0,meal:0,academics:0,sports:0});
            addressToScholarship[studentAddress] = newScholar;
            scholarId++;
        } 
        if(keccak256(bytes(category)) == keccak256(bytes("all"))) {
            addressToScholarship[studentAddress].all += credits;
        }
        if(keccak256(bytes(category)) == keccak256(bytes("meal"))) {
            addressToScholarship[studentAddress].meal += credits;
        }
        if(keccak256(bytes(category)) == keccak256(bytes("academics"))) {
            addressToScholarship[studentAddress].academics += credits;
        }
        if(keccak256(bytes(category)) == keccak256(bytes("sports"))) {
            addressToScholarship[studentAddress].sports += credits;
        }

        totalCredits-=credits;
    }

    //This function is used to register a new merchant who can receive credits from students
    function registerMerchantAddress(address merchantAddress, string memory category) public onlyOwner {
        if (!(keccak256(bytes(category)) == keccak256(bytes("all")) 
        || keccak256(bytes(category)) == keccak256(bytes("meal"))
        || keccak256(bytes(category)) == keccak256(bytes("academics"))
        || keccak256(bytes(category)) == keccak256(bytes("sports"))
        )) revert InvalidCategory();
        if(merchantAddress == msg.sender) revert CannotBeMerchantAndScholar();
        if(addressToScholarship[merchantAddress].id > 0) revert CannotBeMerchantAndScholar();
        // if(addressToMerchant[merchantAddress].id) revert AlreadyMerchant();
        addressToMerchant[merchantAddress].id = merchantId;
        addressToMerchant[merchantAddress].category = category;
        merchantId++;

    }

    //This function is used to deregister an existing merchant
    function deregisterMerchantAddress(address merchantAddress) public onlyOwner{
        if(addressToMerchant[merchantAddress].id < 1) revert NotAMerchant();
        totalCredits+=addressToMerchant[merchantAddress].credits;
        addressToMerchant[merchantAddress].credits = 0;
        delete addressToMerchant[merchantAddress];
    }

    //This function is used to revoke the scholarship of a student
    function revokeScholarship(address studentAddress) public onlyOwner {
        if(addressToScholarship[studentAddress].id < 1) revert NotAScholar();
      
        totalCredits+=addressToScholarship[studentAddress].all;
        totalCredits+=addressToScholarship[studentAddress].meal;
        totalCredits+=addressToScholarship[studentAddress].academics;
        totalCredits+=addressToScholarship[studentAddress].sports;
        
        addressToScholarship[studentAddress].all = 0;
        addressToScholarship[studentAddress].meal = 0;
        addressToScholarship[studentAddress].academics = 0;
        addressToScholarship[studentAddress].sports = 0;
        
        delete addressToScholarship[studentAddress];
    }

    //Students can use this function to transfer credits only to registered merchants
    function spend(address merchantAddress, uint amount) public {
        if(addressToScholarship[msg.sender].id < 1) revert NotAScholar();
        if(addressToMerchant[merchantAddress].id < 1) revert NotAMerchant();
        
        if(keccak256(bytes(addressToMerchant[merchantAddress].category)) == keccak256(bytes("meal"))) {
            if(addressToScholarship[msg.sender].meal + addressToScholarship[msg.sender].all < amount) revert NotEnoughCredits();
            if(addressToScholarship[msg.sender].meal < amount) {
               
                uint diff = amount - addressToScholarship[msg.sender].meal;
                addressToScholarship[msg.sender].meal = 0;
                addressToScholarship[msg.sender].all-=diff;
                
            } else {

                addressToScholarship[msg.sender].meal-=amount;
            }
        }
        if(keccak256(bytes(addressToMerchant[merchantAddress].category)) == keccak256(bytes("academics"))) {
            if(addressToScholarship[msg.sender].academics + addressToScholarship[msg.sender].all < amount) revert NotEnoughCredits();
            if(addressToScholarship[msg.sender].academics < amount) {
               uint diff = amount - addressToScholarship[msg.sender].academics;
               addressToScholarship[msg.sender].academics = 0;
               addressToScholarship[msg.sender].all-=diff;
            } else {

                addressToScholarship[msg.sender].academics-=amount;
            }
        }
        if(keccak256(bytes(addressToMerchant[merchantAddress].category)) == keccak256(bytes("sports"))) {
            if(addressToScholarship[msg.sender].sports + addressToScholarship[msg.sender].all < amount) revert NotEnoughCredits();
            if(addressToScholarship[msg.sender].sports < amount) {
               uint diff = amount - addressToScholarship[msg.sender].sports;
               addressToScholarship[msg.sender].sports = 0;
               addressToScholarship[msg.sender].all-=diff;
            } else {

                addressToScholarship[msg.sender].sports-=amount;
            }
        }
        

        addressToMerchant[merchantAddress].credits+=amount;
    }

    //This function is used to see the available credits assigned.
    function checkBalance(string memory category) public view returns (uint) {
        if (!(keccak256(bytes(category)) == keccak256(bytes("all")) 
        || keccak256(bytes(category)) == keccak256(bytes("meal"))
        || keccak256(bytes(category)) == keccak256(bytes("academics"))
        || keccak256(bytes(category)) == keccak256(bytes("sports"))
        )) revert InvalidCategory();
        if(!(addressToScholarship[msg.sender].id > 0 || addressToMerchant[msg.sender].id > 0 || msg.sender == owner)) revert NotAllowed();
      
        if(addressToMerchant[msg.sender].id > 0) {
            if (keccak256(bytes(category)) == keccak256(bytes("all"))) return addressToMerchant[msg.sender].credits;
            return 0;
        }
        if(addressToScholarship[msg.sender].id > 0) {
            if (keccak256(bytes(category)) == keccak256(bytes("all"))) return addressToScholarship[msg.sender].all;
            if (keccak256(bytes(category)) == keccak256(bytes("meal"))) return addressToScholarship[msg.sender].meal;
            if (keccak256(bytes(category)) == keccak256(bytes("academics"))) return addressToScholarship[msg.sender].academics;
            if (keccak256(bytes(category)) == keccak256(bytes("sports"))) return addressToScholarship[msg.sender].sports;
        }
        
        if (keccak256(bytes(category)) == keccak256(bytes("all"))) return totalCredits;
        return 0;

    }

    //This function is used to see the category under which Merchants are registered
    function showCategory() public view returns (string memory){
        if(addressToMerchant[msg.sender].id < 1) revert NotAMerchant();

        return addressToMerchant[msg.sender].category;
    }
}