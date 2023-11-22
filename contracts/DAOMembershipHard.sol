// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error AlreadyMember();
error AlreadyRejected();
error AlreadyApplied();
error AlreadyVotedForApplicant();
error AlreadyVotedForRemoval();
error NotMember();
error NotApplicant();

contract DAOMembership {

    struct Applicant {
        bool isApplicant;
        uint approvals;
        uint rejections;
    }

    uint256 private members;

    mapping (address => bool) isMemberMap;
    mapping (address => bool) isRejectedMap;
    mapping (address => Applicant) applicants;
    mapping (address => mapping(address => bool)) memberHasVotedForApplicant;
    mapping (address => uint256) removalVotes;
    mapping (address => mapping(address => bool)) memberHasVotedForRemoval;

    constructor() {
        members = 1;
        isMemberMap[msg.sender] = true;
    }

    modifier onlyMember() {
        if(!isMemberMap[msg.sender]) revert NotMember();
        _;
    }

    modifier ifNoMembers() {
        if(members < 1) revert();
        _;
    }

    //To apply for membership of DAO
    function applyForEntry() public ifNoMembers {
        if(isMemberMap[msg.sender]) revert AlreadyMember();
        if(isRejectedMap[msg.sender]) revert AlreadyRejected();
        if(applicants[msg.sender].isApplicant) revert AlreadyApplied();
        Applicant memory newApplicant = Applicant({isApplicant:true,approvals:0,rejections:0});
        applicants[msg.sender] = newApplicant;
    }
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public onlyMember ifNoMembers {
        if(isMemberMap[_applicant]) revert AlreadyMember();
        if(isRejectedMap[_applicant]) revert AlreadyRejected();
        if(!(applicants[_applicant].isApplicant)) revert NotApplicant();
        if(memberHasVotedForApplicant [msg.sender][_applicant]) revert AlreadyVotedForApplicant();
        applicants[_applicant].approvals++;
        memberHasVotedForApplicant[msg.sender][_applicant] = true;
        if (applicants[_applicant].approvals > (members * 3)/10) {
            members++;
            isMemberMap[_applicant] = true;
            delete applicants[_applicant];
        }
    }

    //To disapprove the applicant for membership of DAO
    function disapproveEntry(address _applicant) public onlyMember ifNoMembers {
        if(isRejectedMap[_applicant]) revert AlreadyRejected();
        if(!(applicants[_applicant].isApplicant)) revert NotApplicant();
        if(memberHasVotedForApplicant [msg.sender][_applicant]) revert AlreadyVotedForApplicant();
        applicants[_applicant].rejections++;
        memberHasVotedForApplicant[msg.sender][_applicant] = true;
        if (applicants[_applicant].rejections > (members * 7)/10) {
            isRejectedMap[_applicant] = true;
            delete applicants[_applicant];
        }
    }

    //To remove a member from DAO
    function removeMember(address _memberToRemove) public onlyMember ifNoMembers {
        if(msg.sender == _memberToRemove) revert();
        if(isRejectedMap[_memberToRemove]) revert AlreadyRejected();
         if(!isMemberMap[_memberToRemove]) revert NotMember();
        if(memberHasVotedForRemoval [msg.sender][_memberToRemove]) revert AlreadyVotedForRemoval();
        removalVotes[_memberToRemove]++;
        if (removalVotes[_memberToRemove] > (members * 7)/10) {
            members--;
            delete isMemberMap[_memberToRemove];
            isRejectedMap[_memberToRemove] = true;
        }
        
    }

    //To leave DAO
    function leave() public onlyMember ifNoMembers {
        members--;
        delete isMemberMap[msg.sender];
        isRejectedMap[msg.sender] = true;
    }

    //To check membership of DAO
    function isMember(address _user) public view onlyMember ifNoMembers returns (bool) {
        return (isMemberMap[_user]);
    }

    //To check total number of members of the DAO
    function totalMembers() public view onlyMember ifNoMembers returns (uint256) {
        return members;
    }
}
