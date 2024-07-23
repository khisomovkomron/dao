pragma solidity ^0.8.20;

abstract contract Plutocracy {
    function getOrModifyBlocked(address _account) public virtual returns (bool);
}

abstract contract TokenInterface {
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
    );

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    string public name;
    string public symbol;
    uint  public decimals;

    /// Total amount of tokens
    uint256 public totalSupply;

    /// Governance contract
    Plutocracy plutocracy;


    function balanceOf(address _owner) public virtual returns (uint256 balance);


    function transfer(address _to, uint256 _amount) public virtual returns (bool success);


    function transferFrom(address _from, address _to, uint256 _amount) public virtual returns (bool success);


    function approve(address _spender, uint256 _amount) public virtual returns (bool success);


    function allowance(
        address _owner,
        address _spender
    ) public virtual returns (uint256 remaining);


}

contract Token is TokenInterface {
    
    constructor(Plutocracy _plutocracy) {
        plutocracy = _plutocracy;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public override returns (bool success) {
        if (balances[msg.sender] >= _amount && _amount > 0 && plutocracy.getOrModifyBlocked(_to)) {
            balances[msg.sender] -= _amount;
            balances[_to] -= _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool success) {
        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && plutocracy.getOrModifyBlocked(_to) && plutocracy.getOrModifyBlocked(_from)) {
            balances[_from] -= _amount;
            balances[_to] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function approve(address _spender, uint256 _amount) public override returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) public override view returns(uint256 remaining) {
        return allowed[_owner][_spender];
    }
}