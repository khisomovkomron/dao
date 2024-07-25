// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {VendingMachine} from "../src/DigitalVendingMachine.sol";

contract VendingMachineScript is Script {
    function run() public returns (VendingMachine) {
        vm.startBroadcast();
        VendingMachine vendingMachine = new VendingMachine();

        vm.stopBroadcast();
        return vendingMachine;
    }
}
