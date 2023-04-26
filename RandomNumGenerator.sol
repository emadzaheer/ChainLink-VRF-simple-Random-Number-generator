// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract RandomNumGenerator is VRFV2WrapperConsumerBase {
    event randomNumRequest(uint256 requestId);

    mapping(uint256 => requestStatus) public m_requestStatuses;

    //Change these according to your network and needs 
    address constant linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address constant vrfWrapperAddress = 0x99aFAf084eBA697E584501b8Ed2c0B37Dd136693;
    uint32 constant callbackGasLimit = 100000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 3; // cannot be lower

    constructor() VRFV2WrapperConsumerBase(linkAddress, vrfWrapperAddress) {}

    struct requestStatus {
        uint256 paid;
        uint256 randomWord;
        bool fulfilled;
    }

    //The function that sends the request to generate a random number. 
    //Returns an Id which is used to access the random number using the getStatus function.
    function requestRandomNumber() public returns (uint256) {
        uint256 requestId = requestRandomness(
            callbackGasLimit,
            requestConfirmations,
            numWords
        );

        m_requestStatuses[requestId] = requestStatus({
            paid: VRF_V2_WRAPPER.calculateRequestPrice(callbackGasLimit),
            randomWord: 0,
            fulfilled: false
        });

        emit randomNumRequest(requestId);

        return requestId;
    }

    //when u req randomness, chainlink calls back this function:
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {
        require(m_requestStatuses[requestId].paid > 0, "req not found"); //making sure fee was paid in  link for this reqId

        m_requestStatuses[requestId].fulfilled = true;
        m_requestStatuses[requestId].randomWord = randomWords[0]; //bec we only have one requested word
    }

    //this function will return the random number once you have its request Id.
    function getStatus(uint256 requestId) public view returns (uint256) {
        if (m_requestStatuses[requestId].fulfilled) {
            return m_requestStatuses[requestId].randomWord;
        }
        revert("your request will take some time");
    }

    function withdrawLink() public {
        LinkTokenInterface link = LinkTokenInterface(linkAddress);
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
