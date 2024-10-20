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
        payments[_from ] = msg.value;
    }
}

contract AnotherContract {
    function callGetName(address _contractAddr) public view returns(string memory) {
        return Contract(_contractAddr).getName();
    }

    function callGetterName(Contract addr) public view returns(string memory) {
        return addr.name();
    }

    function callSetName(address contractAddr,string memory _newName) public {
        Contract(contractAddr).setName(_newName);
    }

    function sendFundsThroughContractToAnother(address _contractAddr) public payable {
        Contract(_contractAddr).getFunds{value: msg.value}(msg.sender);
    }
}