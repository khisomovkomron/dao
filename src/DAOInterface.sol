pragma solidity ^0.8.20;

import {Token} from "./TokenCreation.sol";

contract DAOInterface {
    uint256 constant minProposalDatePeriod = 2 weeks;
    uint256 constant quorumHalvingPeriod = 25 weeks;
    uint256 constant executeProposalPeriod = 10 days;
    uint256 constant preSupportTime = 2 days;
    uint256 constant maxDepositDivisor = 100;

    Proposal[] public proposals;
    uint256 public minQuorumDivisor;
    uint256 public lastTimeQuorumMet;

    address public curator;
    mapping(address => bool) public allowedRecipient;
    mapping(address => uint256) public blocked;
    mapping(address => uint256[]) public votingRegister;

    uint256 public proposalDeposit;
    uint256 sumOfProposalDeposits;

    struct Proposal {
        address recipient;
        uint amount;
        string description;
        uint votingDeadline;
        bool open;
        bool proposalPassed;
        bytes32 proposalHash;
        uint proposalDeposit;
        bool newCurator;
        bool preSupport;
        uint yea;
        uint nay;
        mapping(address => bool) votedYes;
        mapping(address => bool) votedNo;
        address creator;
    }

    function() payable;

    function newProposal() public returns (uint _proposalId);

    function checkProposalCode() constant returns (bool _codeCheckout);

    function vote(uint _proposalId, bool _supportsProposal);

    function executeProposal(uint _proposalId, bytes _transactionData) returns (bool _success);
    
    function newContract(address _newContract);

    function changeAllowedRecipients(address _recipient, bool _allowd) external returns (bool _success);

    function changeProposalDeposit(uint _proposalDeposit) external;

    function halveMinQuorum() returns (bool _success);

    function numberOfProposals() constant returns (uint _numberOfProposals);

    function getOrModifyBlocked(address _account) internal returns (bool);

    function unblockeMe() returns (bool);

    event ProposalAdded(
        uint indexed proposalId,
        address recipient,
        uint amount,
        string description 
    );
    event Voted(uint indexed proposalID, bool position, address indexed voter);
    event ProposalTallied(uint indexed prposalID, bool result, uint quorum);
    event allowedRecipientChanged(address indexed _recipient, bool _allowed);
}
