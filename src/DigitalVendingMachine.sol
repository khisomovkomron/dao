// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VendingMachine{

    address public owner;
    mapping (address => uint) public cupcakeBalances;

    constructor() {
        owner = msg.sender;
        cupcakeBalances[address(this)] = 100;
    }

    function refill(uint _amount) public {
        require(msg.sender == owner, "Not the owner");
        cupcakeBalances[address(this)] += _amount;
    }

    function purchase(uint _amount) public payable {
        require(msg.value >= (_amount * 1 ether), "Amount is insufficient");
        require(cupcakeBalances[address(this)] >= _amount, "Amount is greater than Cupcake balance");
        cupcakeBalances[address(this)] -= _amount;
        cupcakeBalances[msg.sender] += _amount;
    }
}