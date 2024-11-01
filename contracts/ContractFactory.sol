// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IContract {
    function addressFactory(address _addr) external view returns(address);
}

contract Contract {
    address public owner;
    address public factory;

    constructor(address _owner) payable  {
        owner = _owner;
        factory = msg.sender;
    }

    function addressFactory() public view returns(address) {
        return factory;
    }
}

contract ContractFactory {
    Contract[] public contracts;

    function deposit() public payable {}

    function getbalance() public view returns(uint) {
        return address(this).balance;
    }

    function createContract(address _addr) public payable {
        Contract newContract = new Contract{value: msg.value}(_addr);
        contracts.push(newContract);
    }

    function getContract(uint _index) public view returns(Contract) {
        return contracts[_index];
    }

    function getFactory(uint _index) public view returns(address) {
        return contracts[_index].addressFactory();
    }

    function getContractBalance(uint _index) public view returns(uint) {
        return address(contracts[_index]).balance;
    }
}