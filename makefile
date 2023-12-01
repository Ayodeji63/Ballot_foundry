-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install Cyfrin/foundry-devops@0.0.11 --no-commit && forge install foundry-rs/forge-std@v1.5.3 --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

ifeq ($(findstring --network polygon,$(ARGS)),--network polygon)
	NETWORK_ARGS := --rpc-url $(POLYGON_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(POLYGON_API_KEY) -vvvv
endif



deployPresidentialElection: 
	@forge script script/DeployPresidentialElection.s.sol:DeployPresidentialElection $(NETWORK_ARGS) --legacy

deployVoterValidation:
	@forge script script/DeployVoterValidation.s.sol:DeployVoterValidation $(NETWORK_ARGS) --legacy

deployCandidateRegistration:
	@forge script script/DeployCandidateRegistration.s.sol:DeployCandidateRegistration $(NETWORK_ARGS) --legacy

deployRPS:
	@forge script script/DeployRPC.s.sol:DeployRPC $(NETWORK_ARGS) --legacy

nominateCandidate:
	@forge script script/Interactions.s.sol:NominateCandidate $(NETWORK_ARGS) --legacy

# castVote:
# 	@forge script script/Interactions.s.sol:CastVote $(NETWORK_ARGS) --legacy

setPresidentialContract: 
	cast send 0xc664550d10954aa53f9a18C2Ad0d60Bf10F03F5f "setPresidentialElectionContract(address)" 0x2A449e71fAa20bd7a134c74160BB06B9E063FD92 --rpc-url $(POLYGON_RPC_URL) --private-key $(PRIVATE_KEY) --legacy

setPresidentialContractCandidate: 
	cast send 0x2d0B3a584Ed635dC643609aBE325EC5a1845F63E "setPresidentialElectionContract(address)" 0x2A449e71fAa20bd7a134c74160BB06B9E063FD92 --rpc-url $(POLYGON_RPC_URL) --private-key $(PRIVATE_KEY) --legacy

castVote:
		cast send 0x2d0B3a584Ed635dC643609aBE325EC5a1845F63E "castVote(string, uint256, uint256)" "90F5**********72" 1 0  --rpc-url $(POLYGON_RPC_URL) --private-key $(PRIVATE_KEY) --legacy


# Pres: 0x2A449e71fAa20bd7a134c74160BB06B9E063FD92
# Voter: 0xc664550d10954aa53f9a18C2Ad0d60Bf10F03F5f
# Candidate: 0x2d0B3a584Ed635dC643609aBE325EC5a1845F63E


