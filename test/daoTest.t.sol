// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {daoScript} from "../script/daoScript.s.sol";
import {DAO} from "../src/DAO.sol";

contract daoTest is Test {
    DAO public dao;
    address payable public vendingMachine;
    daoScript public script;
    string[] public proposalTypes;
    address public voter1;
    address public nonChairPerson;
    uint256 public voteTime;

    function setUp() public {
        vendingMachine = payable(address(0x123));
        voteTime = 1 weeks;
        proposalTypes = ["buy_cupcakes", "no_cupcakes"];

        dao = new DAO(vendingMachine, voteTime, proposalTypes);

        voter1 = address(0x123);
        nonChairPerson = address(0x456);
    }

    function testChairman() public view {
        assertEq(dao.chairPerson(), address(this), "chairPerson not set correctly");
    }

    function testVendingMachineAddress() public view {
        assertEq(dao.VendingMachineAddress(), vendingMachine, "VendingMachineAddress is not set");
    }

    function testVoteEndTime() public view {
        assertEq(dao.voteEndTime(), (block.timestamp + 86400));
    }

    function testDepositEth() public {
        uint256 initialBalance = address(dao).balance;
        vm.deal(voter1, 2 ether);
        vm.prank(voter1);

        dao.DepositEth{value: 0.5 ether}();
        uint256 expectedBalance = initialBalance + 0.5 ether;
        assertEq(expectedBalance, address(dao).balance, "Balance not updated correctly");
        assertEq(dao.balances(voter1), 0.5 ether, "Voter balance not updated");
    }

    function testDepositAfterVotingEnd() public {
        vm.warp(block.timestamp + voteTime + 1);
        vm.deal(voter1, 1 ether);
        vm.prank(voter1);

        vm.expectRevert();
        dao.DepositEth{value: 1}();
    }

    function testDepositEthExceedsLimit() public {
        vm.deal(voter1, 2 ether);
        vm.prank(voter1);

        vm.expectRevert();
        dao.DepositEth{value: 1.5 ether}();
    }

    function testGiveRightVote() public {
        dao.giveRightToVote(voter1);
        DAO.Voter memory voter = dao.getVoter(voter1);

        assertEq(voter.weight, 1, "Voter's weight not set correctly");
    }

    function testGiveRightVoteAlreadyVoted() public {
        dao.giveRightToVote(voter1);

        vm.expectRevert();
        dao.giveRightToVote(voter1);
    }

    function testGiveRightVoteNonChairPerson() public {
        vm.prank(nonChairPerson);

        vm.expectRevert("Only chairperson can give the right to vote");
        dao.giveRightToVote(nonChairPerson);
    }

    function testGiveRightVoteHasAlreadyVote() public {
        dao.giveRightToVote(voter1);
        vm.prank(voter1);
        dao.vote(0);

        vm.expectRevert();
        dao.giveRightToVote(voter1);
    }
}
