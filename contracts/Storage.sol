// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Storage is Ownable(msg.sender) {
  uint myVal;

  event Stored(uint newVal);

  function store(uint _newVal)  external onlyOwner {
    myVal = _newVal;
    emit Stored(myVal);
  }
}