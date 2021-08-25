//SPDX-License-Identifier: GPL-3.int208

pragma solidity >=0.5.0 <0.9.0;

interface ERC20Interface {
    
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferForm(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Crypto is ERC20Interface {
    
    string public name = "My First Crypto";
    string public symbol = "MFC";
    uint public decimals = 0; //Usually 18
    uint public override totalSupply = 1000000;
    
    address public founder;
    mapping(address => uint) public balances;
    
}
