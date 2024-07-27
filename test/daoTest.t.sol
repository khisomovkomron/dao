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

    function setUp() public {
        vendingMachine = payable(address(0x123));
        proposalTypes = ["buy_cupcakes", "no_cupcakes"];

        dao = new DAO(vendingMachine, 86400, proposalTypes);
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
}
