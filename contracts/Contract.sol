// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract {
    string public name = "John";

    mapping (address => uint) public payments;

    function getName() public view returns(string memory) {
        return name;
    }

    function setName(string memory _newName) public {
        name = _newName;
    }

    function getFunds(address _from) public payable {
        payments[_from ] += msg.value;
    }

    receive() external payable {
        payments[msg.sender] += msg.value;
    }

    fallback() external payable {
        payments[msg.sender] += msg.value;
    }
}