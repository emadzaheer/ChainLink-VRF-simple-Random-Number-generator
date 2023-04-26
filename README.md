# ChainLink-VRF-simple-Random-Number-generator
A contract using the direct funding method of chainlink VRF to generate secure and unpredictable random numbers. 
## Network
This contract has its LinkToken address and vrfWrapperAddress set for the polygon mumbai network. To change these visit https://docs.chain.link/vrf/v2/direct-funding/supported-networks/#configurations

## Pre-requisites
send Link tokens to your contract because they will be used as a fee to generate random numbers. Get Link tokens from: https://faucets.chain.link/mumbai?_ga=2.255967691.1341478291.1682492219-794095131.1681194721

## Warning
- There is a delay of atleast 30 seconds for the random number to be available as it requires atleast 3 block confirmations. 
- Requesting a random number and getting its status in the same transaction is not possible. It should be requested in two different calls with a gap of atleast 30 seconds.
