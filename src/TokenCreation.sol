pragma solidity ^0.8.20;

import {Token} from "./Token.sol";
import {Plutocracy} from "./Token.sol";

abstract contract TokenCreationInterface {
    event CreatedToken(address indexed to, uint amount);

    function createTokenProxy(address _tokenHolder) external virtual payable  returns (bool success);

}

contract TokenCreation is TokenCreationInterface, Token {
    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _decimalPlaces,
        Plutocracy _plutocracy
    ) Token(_plutocracy) {
        name = _tokenName;
        symbol = _tokenSymbol;
        decimals = _decimalPlaces;
    }

    function createTokenProxy(address _tokenHolder) public override payable returns (bool success) {
        require(msg.value > 0, "Must send some ether");
        require(address(this).balance + msg.value <= 100000 ether, "Total balance cannot exceed 100000 ether");

        balances[_tokenHolder] += msg.value;
        totalSupply += msg.value;
        emit CreatedToken(_tokenHolder, msg.value);

        return true;
    }
}