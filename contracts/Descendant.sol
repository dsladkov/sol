// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ancestor.sol";
import "./SuperParent.sol";

contract Descendant is Ancestor, SuperParent {
    constructor(string memory name, address _addr) Ancestor(name) SuperParent(_addr) {
    }

}