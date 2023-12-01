// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {CandidateRegistration} from "../src/CandidateRegistration.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployCandidateRegistration is Script {
    address OWNER_ADDRESS = 0xb1f540756bE3c06eBbcAC15d701C5477F271a7a0;
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() external returns (CandidateRegistration) {
        vm.startBroadcast(deployerPrivateKey);
        CandidateRegistration candidateRegistration = new CandidateRegistration(OWNER_ADDRESS);
        HelperConfig helperConfig = new HelperConfig();
        string[] memory partiesParameters = helperConfig.presidentialNominationParameters();
        for (uint256 i = 0; i < partiesParameters.length; i++) {
            candidateRegistration.presidentialNomination(partiesParameters[0]);
        }
        vm.stopBroadcast();
        return candidateRegistration;
    }
}
