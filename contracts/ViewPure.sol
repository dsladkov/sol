// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract ViewAndPure {
  uint256 public x = 1;

  function addX(uint256 y) public view returns(uint256) {
    return x + y;
  }

  function add(uint256 i, uint256 y) public pure returns (uint256) {
    return i + y;
  }
}