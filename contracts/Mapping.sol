// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mapping {
    mapping(string => uint256) public myMap;

    function get(string memory _addr) public view returns(uint256) {
        //Maping always returns a vlaue.abi
        //If the value was never set, it will return the default value
        return myMap[_addr];
    }

    function set(string memory _addr, uint _i) public {
        //Update the value at this address
        myMap[_addr] = _i;
    }

    function remove(string memory _addr) public {
        // Reset the value to the default value
        delete myMap[_addr];
    }
}

contract NestedMapping {
    //Nested mapping (mapping from address to another mapping)
    mapping(string => mapping(uint256 => bool)) public nested;

    function get(string memory _addr, uint _i) public view returns (bool) {
        // You can get values from nested mapping
        // even if it 's not initialized
        return nested[_addr][_i];
    }

    function set(string memory _addr, uint256 _i, bool _boo) public {
        nested[_addr][_i] = _boo;
    }

    function remove(string memory _addr, uint256 _i) public {
        delete nested[_addr][_i];
    }
}