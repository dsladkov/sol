// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract Function {

    event OwnerSet(address indexed anOldOwner, address indexed newOwner);
    address private owner;

    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), msg.sender);
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner is allowed");
        _;
    }
    // Functiona can return multiple values.
    function returnMany() public pure returns (uint256, bool, uint256) {
        return (1, true, 2);
    }
}
