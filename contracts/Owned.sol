// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustomErrors.sol";

contract Owned {
    address public owner;

    modifier isOwner() {
        require(owner == msg.sender, Errors.NotAnOwner());
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}