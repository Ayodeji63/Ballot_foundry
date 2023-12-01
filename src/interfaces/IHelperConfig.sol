// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

contract IHelperConfig {
    struct Voter {
        string firstName;
        string lastName;
        string voterId;
        uint8 stateOfOrigin;
        string localGovernment;
        string gender;
        bool hasVoted;
    }
}
