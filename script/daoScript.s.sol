// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {DAO} from "../src/DAO.sol";

contract daoScript is Script {
    DAO public dao;
    uint public voteTime;
    string[] public proposalTypes;
    address payable public vendingMachine;


    function run() public returns (DAO) {
        vendingMachine = payable(address(0x123));
        voteTime = 1 weeks;
        proposalTypes = ["buy_cupcakes", "no_cupcakes"];

        vm. startBroadcast();
        dao = new DAO();
        dao.initialize(vendingMachine, voteTime, proposalTypes);

        vm.stopBroadcast();
        return dao;

    }
}
