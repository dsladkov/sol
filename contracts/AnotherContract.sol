// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IContract.sol";

error NoSuccessTx();

interface IDelegateContract {
    function pay() external returns(uint);
}

contract AnotherContract {
    address public sender;
    string public name;

    function getBalance() public view returns(uint) {
        return  address(this).balance;
    }
    
    function callGetName(address _contractAddr) public view returns(string memory) {
        return IContract(_contractAddr).getName();
    }

    function callGetterName(address addr) public view returns(string memory) {
        return IContract(addr).name();
    }

    function callSetName(address contractAddr,string memory _newName) public {
        IContract(contractAddr).setName(_newName);
    }

    function sendFundsThroughContractToAnother(address _contractAddr) public payable {
        IContract(_contractAddr).getFunds{value: msg.value}(msg.sender);
    }

    //Below low level call Contract functions
    function lowLevelCallGetName(address _contractAddr) public view returns (string memory) {
        (bool result, bytes memory data) = _contractAddr.staticcall(abi.encodeWithSignature("getName()"));
        require(result, NoSuccessTx());
        return abi.decode(data, (string));
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

    function callGetBalance(address _contractAddr) public view returns(uint){
        (bool result, bytes memory data) = _contractAddr.staticcall(abi.encodeWithSignature("getBalance()"));
        require(result, NoSuccessTx());
        return abi.decode(data, (uint256)); //uint(bytes32(data));
    }

    function callPay(address _demo) external payable {
        (bool result,) = _demo.delegatecall( abi.encodeWithSignature("pay()"));
        require(result, NoSuccessTx());
    }

    function callPayThroughInterface(address _demo) external payable {
    (bool result,) = _demo.delegatecall(abi.encodeWithSelector(IDelegateContract.pay.selector));
    require(result, NoSuccessTx());
    }
}