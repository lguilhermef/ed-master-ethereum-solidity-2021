//SPDX-License-Identifier: GPL-3.int208

pragma solidity >=0.5.0 <0.9.0;

contract Auction {
    
    enum State {
        Started,
        Running,
        Ended,
        Canceled
    }
    
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    uint constant blocksPerWeek = 40320;
    string public ipfsHash;
    State public auctionState;
    uint public highestBindingBid;
    address payable public highestBidder;
    mapping(address => uint) public bidMap;
    uint bidIncrementInWei;
    
    constructor() {
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + blocksPerWeek;
        ipfsHash = "";
        bidIncrementInWei = 100;
    }
    
    modifier notOwner {
        require(msg.sender != owner);
        _;
    }
    
    modifier afterStart {
        require(block.number >= startBlock);
        _;
    }
    
    modifier beforeEnd {
        require(block.number <= endBlock);
        _;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function min(uint a, uint b) pure internal returns(uint){
        uint smallerValue = a <= b ? a : b;
        return smallerValue;
    }
    
    function cancelAuction() public onlyOwner{
        auctionState = State.Canceled;
    }
    
    function placeBid() public payable notOwner afterStart beforeEnd{
        
        require(auctionState == State.Running);
        require(msg.value >= 100);
        
        uint currentBid = bidMap[msg.sender] + msg.value;
        require (currentBid > highestBindingBid);
        
        bidMap[msg.sender] = currentBid;
        
        if (currentBid <= bidMap[highestBidder]) {
            
            highestBindingBid = min(currentBid + bidIncrementInWei, bidMap[highestBidder]);
        } else {
            
            highestBindingBid = min(currentBid, bidMap[highestBidder] + bidIncrementInWei);
            highestBidder = payable(msg.sender);
        }
    }
    
    function finalizeAuction() public {
        
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bidMap[msg.sender] > 0);
        
        address payable recipient;
        uint value;
        
        if (auctionState == State.Canceled) {
            
            recipient = payable(msg.sender);   
            value = bidMap[msg.sender];
        }
            
        if (msg.sender == owner) {
            recipient = owner;
            value = highestBindingBid;
        }
        
        if (msg.sender == highestBidder) {
            recipient = highestBidder;
            value = bidMap[highestBidder] - highestBindingBid;
        }
        
        if ((msg.sender != highestBidder) && (msg.sender != owner)) {
            recipient = payable(msg.sender);
            value = bidMap[msg.sender];
        }
        
        recipient.transfer(value);
    }
}