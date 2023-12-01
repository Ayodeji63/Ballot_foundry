// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {VoterValidation} from "../src/VoterValidation.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IHelperConfig} from "../src/interfaces/IHelperConfig.sol";

contract VoterValidationTest is Test, IHelperConfig {
    VoterValidation voterValidation;
    HelperConfig helperConfig;
    address owner;
    Voter voter;
    address PRANK_PRESIDENTIAL_CONTRACT = makeAddr("presidentialContract");
    address VOTER_1 = makeAddr("voter1");

    event VoterValidated(string indexed voterId, string indexed fullName);

    function setUp() public {
        vm.startBroadcast();
        helperConfig = new HelperConfig();
        owner = helperConfig.getAnvilConfiguration();
        helperConfig.addVoters();
        voterValidation = new VoterValidation(owner);
        vm.stopBroadcast();
    }

    modifier _validateVoter() {
        vm.prank(owner);
        voterValidation.setPresidentialElectionContract(PRANK_PRESIDENTIAL_CONTRACT);
        voter = helperConfig.getVoters(0);
        vm.prank(VOTER_1);
        voterValidation.validateVoter(voter.firstName, voter.voterId, voter.stateOfOrigin);
        _;
    }

    function testvalidateVoter() public {
        voter = helperConfig.getVoters(0);
        vm.expectEmit(false, false, true, true, address(voterValidation));
        emit VoterValidated(voter.voterId, voter.firstName);
        voterValidation.validateVoter(voter.firstName, voter.voterId, voter.stateOfOrigin);
    }

    function testgetVotersCount() public _validateVoter {
        uint256 count = voterValidation.getVotersCount();
        assert(count == 1);
    }

    function testupdateVoterParam() public _validateVoter {
        vm.prank(PRANK_PRESIDENTIAL_CONTRACT);
        voterValidation.updateVoterParam(VOTER_1);
        vm.stopPrank();
        VoterValidation.VoterInfo memory _voter = voterValidation.getVoterInfo(VOTER_1);
        assert(_voter.hasVoted == true);
    }
}
