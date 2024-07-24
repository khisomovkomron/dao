pragma solidity ^0.8.20;

contract VendingMachine{

    address public owner;
    mapping (address => uint) private cupcakeBalances;

    constructor() {
        owner = msg.sender;
        cupcakeBalances[address(this)] = 100;
    }

    function refill(uint _amount) public {
        require(msg.sender == owner);
        cupcakeBalances[address(this)] += _amount;
    }

    function purchase(uint _amount) public payable {
        require(msg.sender > _amount * 1 ether);
        require(cupcakeBalances[address(this)] >= _amount);
        cupcakeBalances[address(this)] -= _amount;
        cupcakeBalances[msg.sender] += _amount;
    }
}