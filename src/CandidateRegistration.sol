pragma solidity ^0.8.18;

import {ICandidateRegistration} from "./interfaces/ICandidateRegistration.sol";

contract CandidateRegistration is ICandidateRegistration {
    error CandidateRegistration__MultipleNominationNotAllowed();
    error CandidateRegistration__CandidateAgeNoValid();
    error CandidateRegistration__OnlyNominatorRole();
    error CandidateRegistration__CandidateNotAllowed();
    error CandidateRegistration__OnlyAdminRole();
    error CandidateRegistration__OnlyPresidentialContract();

    struct Candidates {
        mapping(uint256 => PartyNomination) approvedCandidate;
        uint256 stateId;
    }

    address private immutable admin;
    address private presidentialElectionContract;
    uint256 private s_nominationCount;
    address[] private nominators;
    string[] private s_candidateNames;

    mapping(uint256 => PartyNomination) private presidentialNominationList;
    mapping(uint256 => Candidates) private candidatePerState;
    mapping(uint256 => uint256) public governorshipNominationCountByState;

    event candidateNominated(uint256 partyCount);
    event NominatorAdded(address nominator);

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

    modifier onlyAdminRole() {
        if (msg.sender != admin) {
            revert CandidateRegistration__OnlyAdminRole();
        }
        _;
    }

    modifier onlyPresidentialElectionContract() {
        if (msg.sender != presidentialElectionContract) {
            revert CandidateRegistration__OnlyPresidentialContract();
        }
        _;
    }

    constructor(address i_admin) {
        admin = i_admin;
        nominators.push(admin);
    }

    function setPresidentialElectionContract(address _presidentialElectionContract) external {
        presidentialElectionContract = _presidentialElectionContract;
    }

    function addNominator(address nominator) external onlyAdminRole {
        nominators.push(nominator);
        emit NominatorAdded(nominator);
    }

    function presidentialNomination(string memory partyNomination) external onlyNominatorRole returns (uint256) {
        PartyNomination memory newNomination = PartyNomination({partyParams: partyNomination, voteCount: 0});
        presidentialNominationList[s_nominationCount] = newNomination;
        emit candidateNominated(s_nominationCount);

        for (uint256 i = 1; i <= 36; i++) {
            candidatePerState[i].approvedCandidate[s_nominationCount] = presidentialNominationList[s_nominationCount];
            candidatePerState[i].stateId = i;
        }
        s_nominationCount++;

        return s_nominationCount;
    }

    function incrementCandidateVoteCount(uint256 candidateId, uint256 stateId)
        external
        onlyPresidentialElectionContract
    {
        candidatePerState[stateId].approvedCandidate[candidateId].voteCount++;
    }

    function getAdmin() external view returns (address) {
        return admin;
    }

    function getPartyNomination(uint256 index) external view returns (PartyNomination memory) {
        return presidentialNominationList[index];
    }

    function getNominationCount() external view returns (uint256) {
        return s_nominationCount;
    }

    function getCandidatePerState(uint256 stateId, uint256 candidateId)
        external
        view
        returns (PartyNomination memory)
    {
        return (candidatePerState[stateId].approvedCandidate[candidateId]);
    }
}
