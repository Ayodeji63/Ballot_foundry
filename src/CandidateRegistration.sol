// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ICandidateRegistration} from "./interfaces/ICandidateRegistration.sol";

/**
 * @title Candidates Registration Contract (VoteChain)
 * @author Olusanya Ayodeji
 * @notice This is a Contract For Candidates Nomination For Election On Votechain
 */

contract CandidateRegistration is ICandidateRegistration {
    error CandidateRegistration__MultipleNominationNotAllowed();
    error CandidateRegistration__CandidateAgeNoValid();
    error CandidateRegistration__OnlyNominatorRole();
    error CandidateRegistration__CandidateNotAllowed();
    error CandidateRegistration__OnlyAdminRole();
    error CandidateRegistration__OnlyPresidentialContract();

    struct Candidates {
        mapping(uint256 index => PartyNomination) approvedCandidate;
        uint256 stateId;
    }

    // ? State Variables
    address private immutable admin;
    address private presidentialElectionContract;
    uint256 private s_nominationCount;
    uint256 private approveCandidateCount;
    address[] private nominators;
    address[] private validators;
    string[] private s_candidateNames;
    address private addressOfReceiptFactoryContract;

    mapping(uint256 => PartyNomination) private presidentialNominationList;
    mapping(uint256 => Candidates) private candidatePerState;
    mapping(uint256 => uint256) public governorshipNominationCountByState;

    // ? Events Declarations
    event candidateNominated(uint256 partyCount);
    event NominatorAdded(address nominator);
    event ValidatorAdded(address validator);

    // ? Modifiers

    /**
     * @dev Modifier to ensure that only users with the nominator role can access a function.
     * If the sender is not a nominator, the function call will revert.
     */
    modifier onlyNominatorRole() {
        bool isNominator = false;
        for (uint256 i = 0; i < nominators.length; i++) {
            if (msg.sender == nominators[i]) {
                isNominator = true;
                break;
            }
        }
        if (!isNominator) {
            revert CandidateRegistration__OnlyNominatorRole();
        }
        _;
    }

    /**
     * @dev Modifier to ensure that only the admin can access a function.
     * If the sender is not the admin, the function call will revert.
     */
    modifier onlyAdminRole() {
        if (msg.sender != admin) {
            revert CandidateRegistration__OnlyAdminRole();
        }
        _;
    }

    /**
     * @dev Modifier to ensure that only the presidential election contract can access a function.
     * If the sender is not the presidential election contract, the function call will revert.
     */
    modifier onlyPresidentialElectionContract() {
        if (msg.sender != presidentialElectionContract) {
            revert CandidateRegistration__OnlyPresidentialContract();
        }
        _;
    }

    constructor(address i_admin) {
        admin = i_admin;
        nominators.push(admin);
        validators.push(admin);
    }

    ///////////////////////////////
    //      Admin Role      //
    //////////////////////////////

    /**
     * @dev Sets the address of the presidential election contract.
     * Can only be called by the admin of the contract.
     *
     * @param _presidentialElectionContract The address of the presidential election contract.
     */
    function setPresidentialElectionContract(address _presidentialElectionContract) external {
        presidentialElectionContract = _presidentialElectionContract;
    }

    /**
     * @dev Adds a new Nominator to the contract.
     * @param nominator Address of the new nominator.
     */
    function addNominator(address nominator) external onlyAdminRole {
        nominators.push(nominator);
        emit NominatorAdded(nominator);
    }

    ///////////////////////////////
    //      Nominator Role      //
    //////////////////////////////

    /**
     * @dev Allows a Nominator to nominate presidential candidates.
     * @notice Uses CEI (Check, Effects, Interaction)
     * @param partyNomination party Nomination parameters.
     */
    function presidentialNomination(string memory partyNomination) external onlyNominatorRole returns (uint256) {
        PartyNomination memory newNomination = PartyNomination({partyParams: partyNomination, voteCount: 0});
        presidentialNominationList[s_nominationCount] = newNomination;
        emit candidateNominated(s_nominationCount);

        // Loop through all states (1 to 36) and update their approved candidate mapping
        for (uint256 i = 1; i <= 37; i++) {
            candidatePerState[i].approvedCandidate[s_nominationCount] = presidentialNominationList[s_nominationCount];
            candidatePerState[i].stateId = i;
        }
        s_nominationCount++;

        return s_nominationCount;
    }

    /**
     * @dev Increments the vote count for a specific candidate in a given state.
     * This function can only be called by the presidential election contract.
     * @param candidateId ID of the candidate whose vote count is to be incremented.
     * @param stateId ID of the state where the candidate is nominated.
     */
    function incrementCandidateVoteCount(uint256 candidateId, uint256 stateId)
        external
        onlyPresidentialElectionContract
    {
        // Increment the vote count for the specified candidate in the specified state
        candidatePerState[stateId].approvedCandidate[candidateId].voteCount++;

        // Log the updated vote count for reference
    }

    ///////////////////////////////
    // View and Pure Functions //
    //////////////////////////////
    /**
     * @dev Returns the contract's admin address.
     * @return The address of the contract admin.
     */
    function getAdmin() external view returns (address) {
        return admin;
    }

    /**
     * @dev Returns the PartyNomination information for a given index.
     * @param index Index of the PartyNomination.
     * @return PartyNomination struct for the specified index.
     */
    function getPartyNomination(uint256 index) external view returns (PartyNomination memory) {
        return presidentialNominationList[index];
    }

    /**
     * @dev Returns the count of presidential nominations.
     * @return The count of presidential nominations.
     */
    function getNominationCount() external view returns (uint256) {
        return s_nominationCount;
    }

    /**
     * @dev Returns the approved candidate details for a specific state and candidate ID.
     * @param stateId ID of the state.
     * @param candidateId ID of the candidate.
     * @return Candidate's approved details and the state ID.
     */
    function getCandidatePerState(uint256 stateId, uint256 candidateId)
        external
        view
        returns (PartyNomination memory)
    {
        return (candidatePerState[stateId].approvedCandidate[candidateId]);
    }

    function getApproveCandidateCount() external view returns (uint256) {
        return approveCandidateCount;
    }
}
