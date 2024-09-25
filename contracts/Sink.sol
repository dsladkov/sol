// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract Sink {
  event Received(address indexed from, uint amount, uint timestamp);

  receive() external payable {
    emit Received(msg.sender, msg.value, block.timestamp);
  }
}

