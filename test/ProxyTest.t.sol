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


        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature("initialize(address,uint256,string[])", vendingMachineAddress, voteTime, proposalNames)
        );
        require(success, "Initialization failed");

        daoProxy = DAO(address(proxy));
    }

    function testProxyFunctionality() public {
        daoProxy.giveRightToVote(admin);

        DAO.Voter memory voter = daoProxy.getVoter(admin);
        assertEq(voter.weight, 1, "Admin's weight not set correctly through proxy");

        daoProxy.DepositEth{value: 1 ether}();

        assertEq(daoProxy.balances(admin), 1 ether, "Admin's balance not updated correctly through proxy");
        assertEq(daoProxy.DAObalance(), 1 ether, "DAO balance not updated correctly through proxy");

    }

    function testUpgradeFunctionality() public {
        DAO newDaoImplementation = new DAO();

        proxy.ugradeTo(address(newDaoImplementation));

        daoProxy = DAO(address(proxy));

        daoProxy.giveRightToVote(admin);

        DAO.Voter memory voter = daoProxy.getVoter(admin);

        assertEq(voter.weight, 1, "Admin's weight not set correctly after upgrade through proxy");

    }
}



