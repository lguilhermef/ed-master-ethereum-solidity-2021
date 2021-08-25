//SPDX-License-Identifier: GPL-3.0

pragma solidity >0.6.0 <0.9.0;

contract CrowdFunding {
    
    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint numOfVotes;
        mapping(address => bool) voters;
    }
    
    
    
    address public admin;
    mapping(address => uint) public contributors;
    uint public numOfContributors;
    uint public minimumContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;
    mapping(uint => Request) requests;
    uint public numRequests;
    
    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }
    
    event ContributeEvent(address _send, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePaymentEvent(address _recipient, uint _value);
    
    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }
    
    function contribute() public payable {
        
        require(block.timestamp < deadline);
        require(msg.value >= minimumContribution, "Minimum Contribution not met.");
        
        if (contributors[msg.sender] == 0) {
            numOfContributors++;
        }
        
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
        
        emit ContributeEvent(msg.sender, msg.value);
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function getRefund() public {
        
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributors[msg.sender] > 0);
        
        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];
        recipient.transfer(value);
        
        contributors[msg.sender] = 0;
    }
    
    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
        
        Request storage newRequest = requests[numRequests];
        numRequests++;
        
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.numOfVotes = 0;
        
        emit CreateRequestEvent(_description, _recipient, _value);
    }
    
    function voteRequest(uint _requestNum) public {
        
        require(contributors[msg.sender] > 0, "In order to vote, you must be a contributor.");
        
        Request storage thisRequest = requests[_requestNum];
        
        require(thisRequest.voters[msg.sender] == false, "You have already voted.");
        
        thisRequest.voters[msg.sender] = true;
        thisRequest.numOfVotes++;
    }
    
    function makePayment(uint _requestNum) public onlyAdmin {
        
        require(raisedAmount >= goal);
        
        Request storage thisRequest = requests[_requestNum];
        
        require(thisRequest.completed == false, "The request has been completed.");
        require(thisRequest.numOfVotes > (numOfContributors / 2), "Not enough votes for this request.");

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
        
        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    } 
    
    receive() payable external {
        contribute();
    }
    
}