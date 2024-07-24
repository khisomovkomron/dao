// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TokenCreation} from "./TokenCreation.sol";
import {VendingMachine} from "./DigitalVendingMachine.sol";

contract DAO{

    address payable VendingMachineAddress;
    uint public voteEndTime;
    uint public DAObalance;

    mapping(address => uint) balances;
    uint public decision;
    bool public ended;

    struct Voter{
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal{
        string name; 
        uint voteCount;
    }

    address public chairPerson;

    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    constructor(
        address payable _VendingMachineAddress,
        uint _voteTime,
        string[] memory proposalNames
    ){
        VendingMachineAddress = _VendingMachineAddress;
        chairPerson = msg.sender;

        voteEndTime = block.timestamp + _voteTime;
        voters[chairPerson].weight = 1;

        for (uint i=0; i < proposalNames.length; i++) {
            proposals.push(
                Proposal({
                    name: proposalNames[i],
                    voteCount: 0
                })
            );
        }
    }

    
} 
