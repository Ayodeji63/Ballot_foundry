// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ICandidateRegistration} from "./interfaces/ICandidateRegistration.sol";
import {IVotingStorage} from "./interfaces/IVotingStorage.sol";

/**
 * @title Presidential Election Contract (VoteChain)
 * @notice This contract handles the presidential election process.
 */
contract PresidentialElection {
    // Errors Declaration
    error PresidentialElection__VotingClosed();
    error PresidentialElection__VotingStillOpen();
    error PresidentialElection__VoterNotRegistered();
    error PresidentialElection__AlreadyVoted();

    // Interface Declaration
    ICandidateRegistration public CandidateRegistration;
    IVotingStorage public VoterValidation;

    // State Declaration
    uint256 private duration = block.timestamp + (24 * 3600);

    // Event Declaration
    event VoteCasted(string voterId, uint256 candidateId);
    event WinnerDeclared(uint256 winner);
    event RunOffRequired();

    mapping(uint256 => uint256) public candidateTotalVotes;

    /**
     * @dev Constructor to initialize the contract with Candidate Registration and Voter Registration addresses.
     * @param i_candidateRegistration Address of the Candidate Registration contract.
     * @param i_VoterValidation Address of the Voter Registration contract.
     */
    constructor(address i_candidateRegistration, address i_VoterValidation) {
        CandidateRegistration = ICandidateRegistration(i_candidateRegistration);
        VoterValidation = IVotingStorage(i_VoterValidation);
    }

    /**
     * @dev Adds 24 hours to the current time to extend the voting duration.
     */
    function add24Hours() external {
        uint256 currentTime = block.timestamp;
        duration = currentTime + (24 * 3600); // Adding 24 hours in seconds
    }

    /**
     * @dev Casts a vote in the presidential election.
     * @param voterId Voter ID of the voter.
     * @param stateId State ID where the vote is casted.
     * @param candidateId ID of the candidate being voted for.
     */
    function castVote(string memory voterId, uint256 stateId, uint256 candidateId) external {
        if (block.timestamp > duration) {
            revert PresidentialElection__VotingClosed();
        }
        if (!searchVoter(voterId)) {
            revert PresidentialElection__VoterNotRegistered();
        }

        IVotingStorage.VoterInfo memory voterInfo = VoterValidation.getVoterInfo(msg.sender);
        if (voterInfo.hasVoted) {
            revert PresidentialElection__AlreadyVoted();
        }

        VoterValidation.updateVoterParam(msg.sender);
        CandidateRegistration.incrementCandidateVoteCount(candidateId, stateId);
        voterInfo.hasVoted = true;
        emit VoteCasted(voterId, candidateId);
        // Update the candidate's total votes in the mapping
        candidateTotalVotes[candidateId] += 1;
    }

    /**
     * @dev Searches for a voter based on their voter ID.
     * @param voterId Voter ID to search for.
     * @return Whether the voter with the given ID exists.
     */
    function searchVoter(string memory voterId) internal view returns (bool) {
        for (uint256 i = 0; i < VoterValidation.getAllVoter().length; i++) {
            if (keccak256(bytes(VoterValidation.getAllVoter()[i])) == keccak256(bytes(voterId))) {
                return true;
            }
        }
        return false;
    }

    function totalStateVotes(uint256 stateId) public view returns (uint256) {
        require(stateId >= 1 && stateId <= 37, "Invalid state ID");

        uint256 totalVotes = 0;
        for (uint256 candidateId = 0; candidateId < CandidateRegistration.getNominationCount(); candidateId++) {
            totalVotes += CandidateRegistration.getCandidatePerState(stateId, candidateId).voteCount;
        }

        return totalVotes;
    }

    function calculateWinner() external returns (uint256 highestVotes, uint256 candidateId) {
        if (block.timestamp < duration) {
            revert PresidentialElection__VotingStillOpen();
        }

        highestVotes = 0;
        uint256 winnerCandidateId;

        // Step 1: Calculate Total Votes and Candidate with Highest Votes
        for (candidateId = 0; candidateId < CandidateRegistration.getNominationCount(); candidateId++) {
            uint256 totalCandidateVotes = 0;
            for (uint256 stateId = 1; stateId <= 37; stateId++) {
                totalCandidateVotes += CandidateRegistration.getCandidatePerState(stateId, candidateId).voteCount;
            }
            if (totalCandidateVotes > highestVotes) {
                highestVotes = totalCandidateVotes;
                winnerCandidateId = candidateId;
            }
        }

        // Step 2: Check Quota Requirement
        uint256 requiredStates = 25; // Two-thirds of 37 states

        uint256 statesMeetingQuota = 0;
        for (uint256 stateId = 1; stateId <= 37; stateId++) {
            uint256 winnerVotes = CandidateRegistration.getCandidatePerState(stateId, winnerCandidateId).voteCount;

            // Check if candidate meets 25% quota in the state
            if (winnerVotes >= totalStateVotes(stateId) / 4) {
                statesMeetingQuota++;
            }
        }

        // Step 3: Declare the Winner or Run-Off
        if (statesMeetingQuota >= requiredStates && highestVotes > 0) {
            // Declare the winner
            emit WinnerDeclared(winnerCandidateId);
        } else {
            // Conduct a run-off election within 21 days
            emit RunOffRequired();
        }
    }

    function getTotalVotes() external view returns (uint256 totalVotes) {
        for (uint256 candidateId = 0; candidateId < CandidateRegistration.getNominationCount(); candidateId++) {
            totalVotes += candidateTotalVotes[candidateId];
        }
    }

    function getDuration() external view returns (uint256) {
        return duration;
    }
}
