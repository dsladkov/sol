// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TopParent.sol";

contract Parent is TopParent {

  function parentFunc() public virtual override pure returns(uint) {
    return 42;
  }
}