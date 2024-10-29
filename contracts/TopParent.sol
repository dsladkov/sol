// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TopParent {
  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  function parentFunc() public virtual pure returns(uint) {
    return 1;
  }
}