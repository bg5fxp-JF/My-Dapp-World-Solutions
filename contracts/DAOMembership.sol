// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error AlreadyMember();
error AlreadyApplied();
error AlreadyVotedForApplicant();
error NotMember();
error NotApplicant();

contract DAOMembership {

    struct Applicant {
        bool isApplicant;
        uint votes;
    }

    address[] members;

    mapping (address => bool) isMemberMap;
    mapping (address => Applicant) applicants;
    mapping (address => mapping(address => bool)) memberHasVotedForApplicant;

    constructor() {
        members.push(msg.sender);
        isMemberMap[msg.sender] = true;
    }

    //To apply for membership of DAO
    function applyForEntry() public {
        if(isMemberMap[msg.sender]) revert AlreadyMember();
        if(applicants[msg.sender].isApplicant) revert AlreadyApplied();
        Applicant memory newApplicant = Applicant({isApplicant:true,votes:0});
        applicants[msg.sender] = newApplicant;
    }
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public {
        if(!isMemberMap[msg.sender]) revert NotMember();
        if(isMemberMap[_applicant]) revert AlreadyMember();
        if(!(applicants[_applicant].isApplicant)) revert NotApplicant();
        if(memberHasVotedForApplicant [msg.sender][_applicant]) revert AlreadyVotedForApplicant();
        applicants[_applicant].votes++;
        memberHasVotedForApplicant[msg.sender][_applicant] = true;
        if (applicants[_applicant].votes > (members.length * 3)/10) {
            members.push(_applicant);
            isMemberMap[_applicant] = true;
        }
    }

    //To check membership of DAO
    function isMember(address _user) public view returns (bool) {
        if(!isMemberMap[msg.sender]) revert NotMember();
        return (isMemberMap[_user]);
    }

    //To check total number of members of the DAO
    function totalMembers() public view returns (uint256) {
        if(!isMemberMap[msg.sender]) revert NotMember();
        return members.length;
    }
}
