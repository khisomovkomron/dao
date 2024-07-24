// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TokenCreation} from "./TokenCreation.sol";
import {DAOInterface} from "./DAOInterface.sol";

contract DAO is DAOInterface{
    TokenCreation token; 

    modifier onlyTokenHolders() {
        require(address(msg.sender).balance == 0);
        _;
    }

    constructor(
        address _curator, 
        uint256 _proposalDeposit,
        TokenCreation _token
    ) {
        token = _token;
        curator = _curator;
        proposalDeposit = _proposalDeposit;
        lastTimeQuorumMet = block.timestamp;
        minQuorumDivisor = 7;
    }

    fallback() external override payable {}
    receive() external override payable {}

    function newProposal(
        address _recipient,
        uint256 amount,
        string memory _description,
        bytes memory _transactionData,
        uint64 _debatingPeriod
    ) public override payable onlyTokenHolders returns (uint _proposalID)  {
        require(!allowedRecipient[_recipient]);
        require(_debatingPeriod < minProposalDebatePeriod);
        require(_debatingPeriod > 8 weeks);
        require(msg.value < proposalDeposit);
        require(msg.sender == address(this));
        
    }
} 
