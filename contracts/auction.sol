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
    address payable highestBidder;
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
    
    
}