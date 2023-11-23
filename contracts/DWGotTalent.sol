// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

error NotOwner();
error NotReady();
error AlreadyOwner();
error NotEnough();
error AlreadyFinalist();
error AlreadyJudge();
error NotFinalist();
error CannotVote();
error Started();
error Ended();

contract DWGotTalent {

    struct VotingStatus {
        bool hasSelectedJudges;
        bool hasInputWeight;
        bool hasSelectedFinalists;
        bool hasStartedVoting;
        bool hasEndedVoting;
    }

    address private immutable i_owner;
    VotingStatus private votingStatus;

    mapping(address => address) vote;
    mapping(address => bool) hasVoted;
    mapping(address => bool) isJudge;
    mapping(address => uint256) finalistJudgeVotes;
    mapping(address => uint256) finalistAudienceVotes;
    address[] private voters;
    address[] private finalists;
    address[] private winners;

    uint256 private judgWeight;
    uint256 private audienceWeight;

    constructor() {
        i_owner = msg.sender;
        votingStatus = VotingStatus({
            hasSelectedJudges: false,
            hasInputWeight: false,
            hasSelectedFinalists: false,
            hasStartedVoting: false,
            hasEndedVoting: false
        });
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    modifier endedVoting() {
        if (votingStatus.hasEndedVoting) revert Ended();
        _;
    }

    //this function defines the addresses of accounts of judges
    function selectJudges(address[] memory arrayOfAddresses) public onlyOwner {
        if (arrayOfAddresses.length < 1) revert NotEnough();
        if (votingStatus.hasStartedVoting) revert Started();

        for (uint i; i < arrayOfAddresses.length; i++) 
        {
            if (finalistAudienceVotes[arrayOfAddresses[i]] > 0 || finalistJudgeVotes[arrayOfAddresses[i]] > 0) revert AlreadyFinalist();
            if (arrayOfAddresses[i] == msg.sender) revert AlreadyOwner();
            isJudge[arrayOfAddresses[i]] = true;
        }

        votingStatus.hasSelectedJudges = true;
    }

    //this function adds the weightage for judges and audiences
    function inputWeightage(uint judgeWeightage, uint audienceWeightage) public onlyOwner {
        if (votingStatus.hasStartedVoting) revert Started();

        judgWeight = judgeWeightage;
        audienceWeight = audienceWeightage;
        
        votingStatus.hasInputWeight = true;
    }

    //this function defines the addresses of finalists
    function selectFinalists(address[] memory arrayOfAddresses) public onlyOwner {
        if (votingStatus.hasStartedVoting) revert Started();
        if (arrayOfAddresses.length < 1) revert NotEnough();

         for (uint i; i < arrayOfAddresses.length; i++) 
        {
            if (isJudge[arrayOfAddresses[i]]) revert AlreadyJudge();
            if (arrayOfAddresses[i] == msg.sender) revert AlreadyOwner();
            finalistJudgeVotes[arrayOfAddresses[i]] = 1;
            finalistAudienceVotes[arrayOfAddresses[i]] = 1;
            finalists.push(arrayOfAddresses[i]);
        }
        
        votingStatus.hasSelectedFinalists = true;
    }

    //this function strats the voting process
    function startVoting() public onlyOwner endedVoting {
        if (!votingStatus.hasSelectedJudges || !votingStatus.hasInputWeight || !votingStatus.hasSelectedFinalists) revert NotReady(); 
        votingStatus.hasStartedVoting = true;
    }

    //this function is used to cast the vote 
    function castVote(address finalistAddress) public endedVoting {
        if (!votingStatus.hasStartedVoting) revert NotReady();
        // if (finalistAudienceVotes[msg.sender] > 0 || finalistJudgeVotes[msg.sender] > 0) revert CannotVote();
        if (finalistAudienceVotes[finalistAddress] < 1 || finalistJudgeVotes[finalistAddress] < 1) revert NotFinalist();
        vote[msg.sender] = finalistAddress;
        if(!hasVoted[msg.sender]) voters.push(msg.sender);
    }

    //this function ends the process of voting
    function endVoting() public onlyOwner endedVoting {
        if (!votingStatus.hasStartedVoting) revert NotReady();
        votingStatus.hasEndedVoting = true;

        for (uint i; i < voters.length; i++) 
        {   
            if(isJudge[voters[i]]) {
                finalistJudgeVotes[vote[voters[i]]]++;
                
            } else {
                finalistAudienceVotes[vote[voters[i]]]++;
            }
        }
        uint256 highestVotes;
        for (uint i; i < finalists.length; i++) 
        {   
        
            // finalistJudgeVotes[finalists[i]]--;
            // finalistAudienceVotes[vote[voters[i]]]--;
            
            uint256 totalVotes = (finalistJudgeVotes[finalists[i]] * judgWeight) + (finalistAudienceVotes[finalists[i]] * audienceWeight);
            if(totalVotes == highestVotes) {
                highestVotes = totalVotes;
                winners.push(finalists[i]);
            } else {

                if (totalVotes > highestVotes) {
                    winners = new address[](0);

                    highestVotes = totalVotes;
                    winners.push(finalists[i]);
                }
            }


        }

        
        
    }

    //this function returns the winner/winners
    function showResult() public view returns (address[] memory) {
        if (!votingStatus.hasEndedVoting) revert NotReady();

        return winners;
    }

}