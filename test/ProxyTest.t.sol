pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Proxy} from "../src/Proxy.sol";
import {DAO} from "../src/DAO.sol";

contract ProxyTest is Test {
    DAO public daoImplementation;
    Proxy public proxy;
    DAO public daoProxy;

    address payable public vendingMachineAddress;
    uint public voteTime;
    string[] public proposalNames;
    address public admin;

    function setUp() public {
        admin = address(this);
        vendingMachineAddress = payable(address(0x123));
        voteTime = 1 weeks;
        proposalNames = ["Proposal 1", "Proposal 2", "Proposal 3"];

        daoImplementation = new DAO();

        proxy = new Proxy(address(daoImplementation));

        proxy.setAdmin(admin);

        (bool success, ) = address(proxy).call(abi.encodeWithSignature("initialize(address, uint256, string[])", vendingMachineAddress, voteTime, proposalNames));

        require(success, "Initialization failed");

        daoProxy = DAO(address(proxy));
    }

}



