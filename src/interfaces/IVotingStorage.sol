// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

/**
 * @title Voting Storage Interface
 * @notice This interface defines the data structures used for voting storage.
 */
interface IVotingStorage {
    function getAllVoter() external view returns (string[] memory);

    function getVoterInfo(address voter) external view returns (VoterInfo memory);

    function updateVoterParam(address sender) external;

    function validateVoter(string memory name, string memory voterId, uint256 stateOfOrigin) external;

    /**
     * @dev Voter information structure.
     */
    struct VoterInfo {
        string fullName;
        string voterId;
        uint256 stateOfOrigin;
        bool hasVoted;
    }
}
