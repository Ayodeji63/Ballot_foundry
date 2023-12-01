// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {VoterValidation} from "../src/VoterValidation.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IHelperConfig} from "../src/interfaces/IHelperConfig.sol";

contract DeployVoterValidation is Script, IHelperConfig {
    address OWNER_ADDRESS = 0xb1f540756bE3c06eBbcAC15d701C5477F271a7a0;
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() external returns (VoterValidation) {
        vm.startBroadcast(deployerPrivateKey);
        VoterValidation voterValidation = new VoterValidation(OWNER_ADDRESS);
        HelperConfig helperConfig = new HelperConfig();
        Voter memory voter;
        for (uint256 i = 0; i < 5; i++) {
            voter = helperConfig.getVoters(0);
            voterValidation.validateVoter(voter.firstName, voter.voterId, voter.stateOfOrigin);
        }
        vm.stopBroadcast();
        return voterValidation;
    }
}
