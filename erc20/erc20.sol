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
    uint public override totalSupply;
    
    address public founder;
    mapping(address => uint) public balances;
    
    mapping(address => mapping(address => uint)) allowed;
    
    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }
    
    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public override returns (bool success) {
        
        require(balances[msg.sender] >= tokens);
        
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        
        emit Transfer(msg.sender, to, tokens);
        
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public view override returns(uint){
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        
        allowed[msg.sender][spender] = tokens;
    
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transferForm(address from, address to, uint tokens) public override returns (bool success) {
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        
        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;
        
        return true;
    }
}

contract CryptoICO is Crypto {
    
    address public admin;
    address payable public deposit;
    uint tokenPrice = 0.001 ether;
    uint public hardcap = 300 ether;
    uint public raisedAmount;
    
    uint public saleStart = block.timestamp + 3600; //Starts in one hour, as 3600 are the seconds in a hour.
    uint public saleEnd = block.timestamp + 604800; //ICO ends in one week, which has 604800 seconds.
    uint public tokenTrateStart = saleEnd + 604800;
    
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;
    
    constructor(address payable _deposit) {
        deposit = _deposit;
        admin = msg.sender;
    }
   
}
