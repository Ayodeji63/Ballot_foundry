// SPDX-License-Identifier: MIT

import {Test, console} from "forge-std/Test.sol";
import {CandidateRegistration} from "../../src/CandidateRegistration.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

pragma solidity ^0.8.18;

contract CandidateRegistrationTest is Test {
    event candidateNominated(uint256 partyCount);

    CandidateRegistration candidateRegistrantion;
    HelperConfig helperConfig;
    address owner;
    address PRANK_PRESIDENTIAL_CONTRACT = makeAddr("presidentialContract");

    struct PartyNomination {
        string partyParams;
        uint256 voteCount;
    }

    function setUp() public {
        vm.startBroadcast();
        helperConfig = new HelperConfig();
        owner = helperConfig.getAnvilConfiguration();
        candidateRegistrantion = new CandidateRegistration(owner);
        candidateRegistrantion.setPresidentialElectionContract(PRANK_PRESIDENTIAL_CONTRACT);
        vm.stopBroadcast();
    }

    modifier _nominateCandidate() {
        string[] memory partyParameters = helperConfig.presidentialNominationParameters();
        vm.prank(owner);
        candidateRegistrantion.presidentialNomination(partyParameters[0]);
        _;
    }

    function testpresidentialNomination() public {
        string[] memory partyParameters = helperConfig.presidentialNominationParameters();
        vm.prank(owner);
        vm.expectEmit(false, false, false, false, address(candidateRegistrantion));
        emit candidateNominated(0);
        candidateRegistrantion.presidentialNomination(partyParameters[0]);
    }

    function testgetPartyNomination() public _nominateCandidate {
        CandidateRegistration.PartyNomination memory partNomination = candidateRegistrantion.getPartyNomination(0);
        string[] memory partyParameters = helperConfig.presidentialNominationParameters();
        assertEq(partNomination.partyParams, partyParameters[0]);
    }

    function testgetCandidatePerState() public _nominateCandidate {
        CandidateRegistration.PartyNomination memory partNomination = candidateRegistrantion.getCandidatePerState(1, 0);
        string[] memory partyParameters = helperConfig.presidentialNominationParameters();
        assertEq(partNomination.partyParams, partyParameters[0]);
    }

    function testIncrementCandidateVoteCount() public _nominateCandidate {
        vm.prank(PRANK_PRESIDENTIAL_CONTRACT);
        candidateRegistrantion.incrementCandidateVoteCount(0, 1);
        CandidateRegistration.PartyNomination memory partNomination = candidateRegistrantion.getCandidatePerState(1, 0);
        assert(partNomination.voteCount != 0);
    }
}
