// SPDX-License-Identifier: MIT

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {Script, console} from "forge-std/Script.sol";
import {CandidateRegistration} from "../src/CandidateRegistration.sol";
import {PresidentialElection} from "../src/PresidentialElection.sol";
import {VoterValidation} from "../src/VoterValidation.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IHelperConfig} from "../src/interfaces/IHelperConfig.sol";

pragma solidity ^0.8.18;

contract NominateCandidate is Script {
    HelperConfig helperConfig;
    string[] partyParameters;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("CandidateRegistration", block.chainid);
        helperConfig = new HelperConfig();
        nominatePresidentialCandidate(mostRecentlyDeployed);
        console.log(mostRecentlyDeployed);
    }

    function nominatePresidentialCandidate(address myContract) public {
        vm.startBroadcast();
        partyParameters = helperConfig.presidentialNominationParameters();
        for (uint256 i = 0; i < partyParameters.length; i++) {
            CandidateRegistration(myContract).presidentialNomination(partyParameters[i]);
        }
        vm.stopBroadcast();
    }
}

contract CastVote is Script, IHelperConfig {
    HelperConfig helperConfig;
    string[] partyParameters;
    Voter voter;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("PresidentialElection", block.chainid);
        address helperConfigAddress = DevOpsTools.get_most_recent_deployment("HelperConfig", block.chainid);
        castVote(mostRecentlyDeployed, helperConfigAddress);
    }

    function castVote(address myContract, address helperConfigAddress) public {
        vm.startBroadcast();
        voter = HelperConfig(helperConfigAddress).getVoters(0);
        PresidentialElection(myContract).castVote(voter.voterId, voter.stateOfOrigin, 2);
        vm.stopBroadcast();
    }
}
