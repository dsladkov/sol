// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SuperParent {
    address public owner;
    constructor(address _addr) {
        owner = _addr;
    }
}