// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Errors {
    error NotAnOwner();
}

contract Ownable {
    address owner;

    modifier isOwnable() {
        require(msg.sender == _owner(), Errors.NotAnOwner());
        _;
    }

    function _owner() internal view returns(address) {
        return owner;
    }

    constructor(address _addr){
        owner = _addr;
    }
}

abstract contract UserAbstractSaver is Ownable{
    mapping(address addr => string name) addrNames;


    function receiveName(address _addr, string memory _name) public virtual;

    function saveName(address _addr, string memory _name) internal {
        addrNames[_addr] = _name;
    }

    function getName(address _addr) public view isOwnable returns(string memory) {
        return addrNames[_addr];
    }
}

contract UserSaver is UserAbstractSaver {

    constructor() Ownable(msg.sender) {}

    function receiveName(address _addr, string memory _name) public virtual override {
        super.saveName(_addr, _name);
    }
}