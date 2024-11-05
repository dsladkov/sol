//SPDX-License_Identifier: MIT
pragma solidity ^0.8.0;

library Errors {
  error NotAnOwner();
}

contract Payable {
  address payable public owner;

  modifier onlyOwner() {
    require(msg.sender == owner, Errors.NotAnOwner());
  }
  //Payable constructor can receive Ether
  constructor() payable {
    owner = payable(msg.sender);
  }

  function deposit() public payable{}

  function nonPayable() public {}

  function withdraw() public {

  }
}