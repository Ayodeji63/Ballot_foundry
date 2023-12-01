// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {IVotingStorage} from "./IVotingStorage.sol";

interface ICandidateRegistration {
    // mapping(uint => mapping(uint => GovernorshipNomination))
    //     private governorshipNominationPerState;

    struct PartyNomination {
        string partyParams;
        uint256 voteCount;
    }

    function getPartyNomination(uint256 index) external view returns (PartyNomination memory);

    function getNominationCount() external view returns (uint256);

    // function getNominationState(uint256 nominationId) external view returns (NominationState);

    function getCandidatePerState(uint256 stateId, uint256 candidateId)
        external
        view
        returns (PartyNomination memory);

    function incrementCandidateVoteCount(uint256 candidateId, uint256 stateId) external;

    function getApproveCandidateCount() external view returns (uint256);
}
