// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnglishAuction {
    string public item;
    address payable public immutable seller;
    uint public endAt;
    bool public started;
    bool public ended;
    uint public highestBid;
    address public highestBidder;
    mapping(address bidder => uint bid) public bids;

    event Start(string _item, uint highestBid, uint _timestamp);
    event Bid(address indexed _bidder, uint indexed _bid, uint _timestamp);
    event End(address _highestBidder, uint _bid, uint _timestamp);
    event Withdraw(address indexed _recipient, uint indexed _value, uint _timestamp);

    constructor(string memory _item, uint startedBid) {
        seller = payable(msg.sender);
        item = _item;
        highestBid = startedBid;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "you're not a seller!");
        _;
    }

    modifier hasStarted() {
        require(started, "auction isn't started yet!");
        _;
    }

    modifier notEnded() {
        require(block.timestamp <= endAt, "auction isn't ended yet!");
        ended = true;
        _;
    }

    function start() external onlySeller{
        require(!started, "It has already started!");

        started = true;
        endAt = block.timestamp;// + 120; //it's 120 seconds more than current time

        emit Start(item, highestBid ,block.timestamp);
    }

    function bid() external payable hasStarted {
        require(!ended, "auction is already ended!");
        require(msg.value > highestBid, "your bid isn't more than current bid!");
        if(highestBidder != address(0)) {
            bids[highestBidder] = highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(msg.sender, msg.value, block.timestamp);
    }

    function end() external hasStarted {
        require(block.timestamp >= endAt, "can't stop auction yet!");
        ended = true;
        if(highestBidder != address(0)){
            seller.transfer(highestBid);
        }
        emit End(highestBidder, highestBid, block.timestamp);
    }

    function withdraw() external {
        //require(ended == true, "auction isn't ended yet!");
        uint refundAmount = bids[msg.sender];
        require(refundAmount > 0, "incorrect refund amount!");
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(refundAmount);
        emit Withdraw(msg.sender, refundAmount, block.timestamp);
    }

}