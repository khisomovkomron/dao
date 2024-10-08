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

    function testRefillByNonOwner() public {
        vm.prank(nonOwner);
        uint256 refillAmount = 50;

        vm.expectRevert("Not the owner");

        vendingMachine.refill(refillAmount);
    }

    function testPurchaseWithLessAmount() public {
        vm.deal(address(this), 0.5 ether);
        uint256 amount = 10;
        vm.expectRevert("Amount is insufficient");
        vendingMachine.purchase(amount);
    }

    function testPurchaseWithGreaterAmount() public {
        vm.deal(address(this), 200 ether);

        uint256 amount = 101;
        vm.expectRevert("Amount is greater than Cupcake balance");
        vendingMachine.purchase{value: amount * 1 ether}(amount);
    }
}
