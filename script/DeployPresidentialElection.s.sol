// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {CandidateRegistration} from "../src/CandidateRegistration.sol";
import {VoterValidation} from "../src/VoterValidation.sol";
import {PresidentialElection} from "../src/PresidentialElection.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DeployVoterValidation} from "./DeployVoterValidation.s.sol";
import {DeployCandidateRegistration} from "./DeployCandidateRegistration.s.sol";

contract DeployPresidentialElection is Script {
    PresidentialElection presidentialElection;
    HelperConfig helperConfig;
    DeployCandidateRegistration deployCandidate;
    DeployVoterValidation deployVoterVal;
    CandidateRegistration candidateRegistration;
    VoterValidation voterValidation;
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public returns (PresidentialElection) {
        deployCandidate = new DeployCandidateRegistration();
        (candidateRegistration) = deployCandidate.run();
        deployVoterVal = new DeployVoterValidation();
        (voterValidation) = deployVoterVal.run();

        vm.startBroadcast(deployerPrivateKey);
        presidentialElection = new PresidentialElection(address(candidateRegistration), address(voterValidation));
        vm.stopBroadcast();

        return presidentialElection;
    }
}
