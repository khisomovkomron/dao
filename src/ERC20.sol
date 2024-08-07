pragma solidity ^0.8.20;

import {Initializable} from "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import {OwnableUpgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";


contract NewToken  is Initializable, ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable{

    function initialize() public initializer() {
        __ERC20_init("NewToken", "NWT");
        __Ownable_init(msg.sender);

        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function _authorizeUpgrade(address newImplementations) internal override onlyOwner() {}
}



contract NewTokenV2 is NewToken {
    string vers = "v2!";

    function version() public view returns (string memory) {
        return vers;
    }
}

contract NewTokenV3 is NewToken {
    string vers = "v2!";
    string versv2 = "v3!";

    function version() public view returns (string memory) {
        return versv2;
    }
}