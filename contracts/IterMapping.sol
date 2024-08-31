// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IterMapping {
    address _owner;
    mapping(string _name => uint _age) public ages;
    string[] public keys;

    mapping (string key => bool _isExists) isExists;

    modifier onlyOwner() {
        require(msg.sender == _owner, "you're not an owner!");
        _;
    }

    constructor() {
        _owner = msg.sender;
    }

    function set(string memory _name, uint _age) public onlyOwner {
        if(!isExists[_name])
        {
            isExists[_name] = true;
            ages[_name] = _age;
            keys.push(_name);
        }
    }

    function length() public view onlyOwner returns(uint) {
        return keys.length;
    }

    function get(uint _index) public view onlyOwner returns(uint) {
        return ages[keys[_index]];
    }

    function values() public view onlyOwner returns(uint[] memory) {
        uint[] memory vals = new uint[](keys.length);

        for(uint i = 0; i < vals.length; i++)
        {
            vals[i] = ages[keys[i]];
        }
        return vals;
    }

    function getKeys() external view onlyOwner returns(string[] memory) {
        return keys;
    }
}