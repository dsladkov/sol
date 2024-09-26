// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

type UFixed256x18 is uint256;

contract FixedMath {
  uint constant multiplier = 10**18;

  function add(UFixed256x18 a, UFixed256x18 b) internal pure returns (UFixed256x18) {
    return UFixed256x18.wrap(UFixed256x18.unwrap(a) + UFixed256x18.unwrap(b));
  }

  function mul(UFixed256x18 a, uint256 b) internal pure returns (UFixed256x18) {
    return UFixed256x18.wrap(UFixed256x18.unwrap(a) * b);
  }

  function floor(UFixed256x18 a) internal pure returns (uint256) {
    return UFixed256x18.unwrap(a) / multiplier;
  }

  function toUFixed256x18(uint256 a) internal pure returns (UFixed256x18) {
    return UFixed256x18.wrap(a * multiplier);
  }
}