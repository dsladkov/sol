// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IContract {
    function name() external view returns (string memory);
    function getName() external view returns(string memory);
    function setName(string memory _newName) external;
    function getFunds(address _from) external payable;
    function getBalance() external view returns(uint);
}