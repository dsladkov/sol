// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IContract.sol";

error NoSuccessTx();

contract AnotherContract {
    string public name;
    function callGetName(address _contractAddr) public view returns(string memory) {
        return IContract(_contractAddr).getName();
    }

    // function callGetterName(IContract addr) public view returns(string memory) {
    //     return addr.name();
    // }

    function callSetName(address contractAddr,string memory _newName) public {
        IContract(contractAddr).setName(_newName);
    }

    function sendFundsThroughContractToAnother(address _contractAddr) public payable {
        IContract(_contractAddr).getFunds{value: msg.value}(msg.sender);
    }

    //Below low level call Contract functions
    function lowLevelCallGetName(address _contractAddr) public returns (string memory) {
        (bool result, bytes memory data) = _contractAddr.call(abi.encodeWithSignature("getName()"));

        require(result, NoSuccessTx());
        name = string(abi.encodePacked(data));
        return string(abi.encodePacked(data));
    }

    function lowLevelCallSetName(address _contractAddr, string memory _newName) public {
        (bool result,) = _contractAddr.call(abi.encodeWithSignature("setName(string)", _newName));
        require(result, NoSuccessTx());
    }

    function lowLevelCallGetFunds(address _contractAddr) public payable {
        (bool result,) = _contractAddr.call{value: msg.value}(abi.encodeWithSignature("getFunds(address)", msg.sender));
        require(result, NoSuccessTx());
    }

    function sendFundsToFakeFunc(address _contractAddr) public payable {
        (bool result,) =  _contractAddr.call{value: msg.value}(abi.encodeWithSignature("fake()"));
        require(result, NoSuccessTx());
    }
}