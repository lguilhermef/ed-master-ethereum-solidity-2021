//SPDX-License-Identifier: GPL-3.0

pragma solidity >0.6.0 <0.9.0;

contract CrowdFunding {
    
    address public admin;
    mapping(address => uint) public contributors;
    uint public numOfContributors;
    uint public minimumContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;
    
    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }
    
    function contribute() public payable {
        require(block.timestamp < deadline);
        require(msg.value >= minimumContribution, "Minimum Contribution not met.");
        
        if (contributors[msg.sender] == 0) {
            numOfContributors++;
        }
        
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    receive() payable external {
        contribute();
    }
    
}