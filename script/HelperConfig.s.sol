// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {IHelperConfig} from "../src/interfaces/IHelperConfig.sol";

contract HelperConfig is IHelperConfig {
    string[] partiestMetadata = [
        "https://bafkreiff5zvhsleblzzuoowto2bnpccqhqtycbcmndd4jpwdg4ytthvzpm.ipfs.nftstorage.link/",
        "https://bafkreihdvln3h2zhogh77vw4tqiqnvajdvylvtqddtekdlrnfg6p6jkczq.ipfs.nftstorage.link/",
        "https://bafkreicdyadrt6qcwszrzqid3ffnflpkl4dqj7osdh6bzzwghids4dnvbe.ipfs.nftstorage.link/",
        "https://bafkreibpigmbnubhun6ihuiuv4wfk7moyfmvbbcuzjalo45uhczhoicf7a.ipfs.nftstorage.link/",
        "https://bafkreidojdzaijasfyp65yypbufw7qgtbckt2nrpmf7gemvlfrnbgrbbta.ipfs.nftstorage.link/",
        "https://bafkreifgfqfkhuip6wbxipyetzhg6lfnqan7btplhrb6qpbkp4v7sz7oti.ipfs.nftstorage.link/",
        "https://bafkreicwgy4pkdo53ro3w3tsfsov7223yqekznyb7l46d5lzjhnaemfh6u.ipfs.nftstorage.link/",
        "https://bafkreid5fgs6torktizqu77j6tgdrpx27mkimbsdmb7s4zdyayugztexvi.ipfs.nftstorage.link/",
        "https://bafkreic3i2bmord6x6mcph523juvdndke6jpsaebotfhzejic3haf4rm6q.ipfs.nftstorage.link/"
    ];

    Voter[] public voters;

    constructor() {}

    function addVoters() public {
        voters.push(
            Voter({
                firstName: "John",
                lastName: "Doe",
                voterId: "90F5**********72",
                stateOfOrigin: 1, // Abia
                localGovernment: "Umuahia",
                gender: "M",
                hasVoted: false
            })
        );

        voters.push(
            Voter({
                firstName: "Jane",
                lastName: "Smith",
                voterId: "40F5**********72",
                stateOfOrigin: 2, // Adamawa
                localGovernment: "Yola",
                gender: "F",
                hasVoted: false
            })
        );

        voters.push(
            Voter({
                firstName: "David",
                lastName: "Williams",
                voterId: "50F5**********72",
                stateOfOrigin: 3, // Akwa Ibom
                localGovernment: "Uyo",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Olivia",
                lastName: "Johnson",
                voterId: "60F5**********72",
                stateOfOrigin: 1, // Anambra
                localGovernment: "Awka",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Michael",
                lastName: "Brown",
                voterId: "70F5**********72",
                stateOfOrigin: 2, // Bauchi
                localGovernment: "Bauchi",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Emily",
                lastName: "Jones",
                voterId: "80F5**********72",
                stateOfOrigin: 3, // Bayelsa
                localGovernment: "Yenagoa",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Daniel",
                lastName: "Martinez",
                voterId: "20F5**********72",
                stateOfOrigin: 1, // Benue
                localGovernment: "Makurdi",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Sophia",
                lastName: "Garcia",
                voterId: "30F5**********72",
                stateOfOrigin: 2, // Borno
                localGovernment: "Maiduguri",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Ethan",
                lastName: "Lopez",
                voterId: "10F5**********72",
                stateOfOrigin: 3, // Cross River
                localGovernment: "Calabar",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Isabella",
                lastName: "Harris",
                voterId: "110F5**********72",
                stateOfOrigin: 1, // Delta
                localGovernment: "Asaba",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Aiden",
                lastName: "Miller",
                voterId: "120F5**********72",
                stateOfOrigin: 2, // Ebonyi
                localGovernment: "Abakaliki",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Mia",
                lastName: "Wilson",
                voterId: "130F5**********72",
                stateOfOrigin: 3, // Edo
                localGovernment: "Benin City",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Liam",
                lastName: "Moore",
                voterId: "140F5**********72",
                stateOfOrigin: 4, // Ekiti
                localGovernment: "Ado Ekiti",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Ella",
                lastName: "Walker",
                voterId: "150F5**********72",
                stateOfOrigin: 1, // Enugu
                localGovernment: "Enugu",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Noah",
                lastName: "Hill",
                voterId: "160F5**********72",
                stateOfOrigin: 2, // Gombe
                localGovernment: "Gombe",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Ava",
                lastName: "Flores",
                voterId: "170F5**********72",
                stateOfOrigin: 3, // Imo
                localGovernment: "Owerri",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "James",
                lastName: "Cooper",
                voterId: "180F5**********72",
                stateOfOrigin: 1, // Jigawa
                localGovernment: "Dutse",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Lily",
                lastName: "Carter",
                voterId: "190F5**********72",
                stateOfOrigin: 2, // Kaduna
                localGovernment: "Kaduna",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "William",
                lastName: "Perez",
                voterId: "200F5**********72",
                stateOfOrigin: 3, // Kano
                localGovernment: "Kano",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Sofia",
                lastName: "Turner",
                voterId: "210F5**********72",
                stateOfOrigin: 4, // Katsina
                localGovernment: "Katsina",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "William",
                lastName: "Turner",
                voterId: "160F5**********72",
                stateOfOrigin: 4, // Gombe
                localGovernment: "Gombe",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Sofia",
                lastName: "Perez",
                voterId: "170F5**********72",
                stateOfOrigin: 5, // Imo
                localGovernment: "Owerri",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "James",
                lastName: "Cooper",
                voterId: "180F5**********72",
                stateOfOrigin: 1, // Jigawa
                localGovernment: "Dutse",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Grace",
                lastName: "Rodriguez",
                voterId: "190F5**********72",
                stateOfOrigin: 2, // Kaduna
                localGovernment: "Kaduna",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Benjamin",
                lastName: "Flores",
                voterId: "200F5**********72",
                stateOfOrigin: 3, // Kano
                localGovernment: "Kano",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Chloe",
                lastName: "Lee",
                voterId: "210F5**********72",
                stateOfOrigin: 4, // Katsina
                localGovernment: "Katsina",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Henry",
                lastName: "Hernandez",
                voterId: "220F5**********72",
                stateOfOrigin: 5, // Kebbi
                localGovernment: "Birnin Kebbi",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Zoe",
                lastName: "Nguyen",
                voterId: "230F5**********72",
                stateOfOrigin: 1, // Kogi
                localGovernment: "Lokoja",
                gender: "F",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Jackson",
                lastName: "Brown",
                voterId: "240F5**********72",
                stateOfOrigin: 2, // Kwara
                localGovernment: "Ilorin",
                gender: "M",
                hasVoted: false
            })
        );
        voters.push(
            Voter({
                firstName: "Penelope",
                lastName: "Scott",
                voterId: "250F5**********72",
                stateOfOrigin: 3, // Lagos
                localGovernment: "Lagos Island",
                gender: "F",
                hasVoted: false
            })
        );
    }

    function presidentialNominationParameters() public view returns (string[] memory) {
        return partiestMetadata;
    }

    function getAnvilConfiguration() public view returns (address) {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        return owner;
    }

    function getVoters(uint256 index) public view returns (Voter memory) {
        return voters[index];
    }
}
