// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {VendingMachine} from "./DigitalVendingMachine.sol";

contract DAO{

    address payable public VendingMachineAddress;
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

    error voteAlreadyEnded();

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

    function DepositEth() public payable {
        DAObalance = address(this).balance;

        if (block.timestamp > voteEndTime) {
            revert voteAlreadyEnded();
        }

        require(DAObalance <= 1 ether, "1 Ether balance has been reached");
        balances[msg.sender] += msg.value;
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == chairPerson, "Only chairperson can give the right to vote");
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    function countVote() public returns (uint winningProposal) {
        require(block.timestamp > voteEndTime, "Vote not ended yet");

        uint winningVoteCount = 0;

        for (uint p=0; p < proposals.length; p++) {
            if(proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;

                decision = winningProposal;
                ended = true;
            }
        }
    }

    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "amount > balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        DAObalance = address(this).balance;
    }

    function endVote() public {
        require(block.timestamp > voteEndTime, "Vote not ended yet");
        require(ended == true, "Must count vote first");
        require(DAObalance >= 1 ether, "Not enough balance in DAO required to buy cupcakes. Members may withdraw deposited ether");

        if (DAObalance < 1 ether) revert();
            (bool success, ) = address(VendingMachineAddress).call{value: 1 ether}(abi.encodeWithSignature("purchase(uint256)", 1));

        DAObalance = address(this).balance;
    }

    function checkCupcakesBalance() public view returns (uint) {
        VendingMachine vendingMachine = VendingMachine(VendingMachineAddress);
        return vendingMachine.cupcakeBalances(address(this));
    }
} 
