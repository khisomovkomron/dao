pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {VendingMachineScript} from "../script/VendingMachineScript.s.sol";
import {VendingMachine} from "../src/DigitalVendingMachine.sol";

contract VendingMachineTest is Test {
    VendingMachine vendingMachine;
    address owner;
    address nonOwner;

    function setUp() public {
        owner = address(this);
        nonOwner = address(0x1234); // example non-owner address

        vendingMachine = new VendingMachine();
    }

    function testRefillByOwner() public {
        uint256 initialBalance = vendingMachine.cupcakeBalances(address(vendingMachine));
        uint256 refillAmount = 50;

        vendingMachine.refill(refillAmount);
        uint256 expectedBalance = initialBalance + refillAmount;
        uint256 actualBalance = vendingMachine.cupcakeBalances(address(vendingMachine));

        assertEq(expectedBalance, actualBalance, "Owner should be able to refill");
    }
}
