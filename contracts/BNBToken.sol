// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BNBToken
 * @dev Implementation of BNB Network Token Contract
 * @author RoyalSmurfy
 */

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BNBToken is IERC20 {
    string public name = "BNB Network Token";
    string public symbol = "BNB";
    uint8 public decimals = 18;
    uint256 private _totalSupply;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    address public owner;
    
    event Burn(address indexed burner, uint256 value);
    event Mint(address indexed to, uint256 value);
    
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "Transfer to zero address");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address _owner, address spender) public view override returns (uint256) {
        return _allowances[_owner][spender];
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(sender != address(0), "Transfer from zero address");
        require(recipient != address(0), "Transfer to zero address");
        require(_balances[sender] >= amount, "Insufficient balance");
        require(_allowances[sender][msg.sender] >= amount, "Allowance exceeded");
        
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Mint to zero address");
        _totalSupply += amount;
        _balances[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }
    
    function burn(uint256 amount) public {
        require(_balances[msg.sender] >= amount, "Insufficient balance to burn");
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }
    
    function burnFrom(address account, uint256 amount) public {
        require(_allowances[account][msg.sender] >= amount, "Allowance exceeded");
        _balances[account] -= amount;
        _totalSupply -= amount;
        _allowances[account][msg.sender] -= amount;
        emit Burn(account, amount);
        emit Transfer(account, address(0), amount);
    }
}
