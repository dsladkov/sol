// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract EnumTest {
  enum ActionChoices {GoLeft, GoRight, GoStraight, SitStill}
  ActionChoices choice;
  ActionChoices constant defaultChoice = ActionChoices.GoStraight;

  function setGoStraight() public {
    choice = ActionChoices.GoStraight;
  }

  function getChoice() public view returns(ActionChoices) {
    return choice;
  }

  function getDefaultChoice() public pure returns(uint) {
    return uint(defaultChoice);
  }

  function getLargestValue() public pure returns(ActionChoices) {
    return type(ActionChoices).max;
  }

  function getSmallestValue() public pure returns (ActionChoices) {
    return type(ActionChoices).min;
  }
}