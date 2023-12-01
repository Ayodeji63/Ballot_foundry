// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {IVotingStorage} from "./interfaces/IVotingStorage.sol";

/**
 * @title Voters Registration Contract (VoteChain)
 * @notice This contract handles the registration of voters.
 */
contract VoterValidation is IVotingStorage {
    // Error messages
    error VoterValidation__RegistrationClosed();
    error VoterValidation__OnlyAdminRole();
    error VoterValidation__OnlyPresidentialContract();

    // State Variables
    uint256 private s_votersCount;
    address private presidentialContract;
    uint256 private futureTime = block.timestamp + (24 * 3600); // Set 24 hours from deployment
    string[] private voterIdStorage;
    address private immutable admin;

    // Mapping to store voter info by voter ID
    mapping(address => VoterInfo) public voters;

    // Event to log voter registration
    event VoterValidated(string indexed voterId, string indexed fullName);

    // Modifiers

    /**
     * @dev Throws if called by any account other than the presidential contract.
     */
    modifier onlyPresidentialElectionContract() {
        if (msg.sender != presidentialContract) {
            revert VoterValidation__OnlyPresidentialContract();
        }
        _;
    }

    /**
     * @dev Throws if called by any account other than the admin.
     */
    modifier onlyAdminRole() {
        if (msg.sender != admin) {
            revert VoterValidation__OnlyAdminRole();
        }
        _;
    }

    constructor(address i_admin) {
        admin = i_admin;
    }

    /**
     * @dev Sets the address of the presidential contract.
     * @param _presidentialElectionContract Address of the presidential contract.
     */
    function setPresidentialElectionContract(address _presidentialElectionContract) external onlyAdminRole {
        presidentialContract = _presidentialElectionContract;
    }

    function validateVoter(string memory name, string memory voterId, uint256 stateOfOrigin) external {
        // Create a new VoterInfo struct with provided data
        VoterInfo memory voterInfo =
            VoterInfo({fullName: name, voterId: voterId, stateOfOrigin: stateOfOrigin, hasVoted: false});

        // Store the voter information in the mapping
        voters[msg.sender] = voterInfo;
        voterIdStorage.push(voterId);

        // Emit an event to log the voter's registration
        emit VoterValidated(voterId, name);

        // Increment the total voters count
        s_votersCount++;
    }

    /**
     * @dev Updates the "hasVoted" status of a voter.
     */
    function updateVoterParam(address sender) external onlyPresidentialElectionContract {
        VoterInfo storage voterInfo = voters[sender];
        voterInfo.hasVoted = true;
        voters[sender] = voterInfo;
    }

    /**
     * @dev Adds 24 hours to the current time to close the registration.
     */
    function add24Hours() external {
        uint256 currentTime = block.timestamp;
        futureTime = currentTime + (24 * 3600); // Adding 24 hours in seconds
    }

    // View and Pure Functions

    /**
     * @dev Returns the voter information for a given voter ID.
     *
     * @return VoterInfo struct containing voter information.
     */
    function getVoterInfo(address voter) external view returns (VoterInfo memory) {
        return voters[voter];
    }

    /**
     * @dev Returns the total count of registered voters.
     * @return The total count of registered voters.
     */
    function getVotersCount() external view returns (uint256) {
        return s_votersCount;
    }

    /**
     * @dev Returns an array of all registered voter IDs.
     * @return An array containing all registered voter IDs.
     */
    function getAllVoter() external view returns (string[] memory) {
        return voterIdStorage;
    }
}
