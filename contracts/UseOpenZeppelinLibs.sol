// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract UseOpenZeppelinLibs {
  using SafeCast for uint;


  function testSafeCastToUint8(uint _num) public pure returns(uint8) {
    return SafeCast.toUint8(_num);
  }
}

