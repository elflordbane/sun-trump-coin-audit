// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SunTrumpCoin {
    string public name = "Sun Trump Coin";
    string public symbol = "STC";
    uint8 public decimals = 6;
    uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
    address public owner;
    uint8 public mode = 0;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }

    function setMode(uint8 _mode) public onlyOwner {
        mode = _mode;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (mode == 1 && msg.sender != owner && _to != owner) revert("Transfers restricted");
        require(balanceOf[msg.sender] >= _value, "Insufficient");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    // Add approve, transferFrom, and other TRC-20 interface functions as needed
}
