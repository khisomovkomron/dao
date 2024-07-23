pragma solidity ^0.8.20;

import {Token} from "./Token.sol";

abstract contract TokenCreationInterface {
    event CreatedToken(address indexed to, uint amount);

    function createTokenProxy(address _tokenHolder) external virtual payable  returns (bool success);

}