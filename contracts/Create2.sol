// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


event Deployed(address _owner, uint value);
event Deploy(address _contract);

contract Demo {

    address public owner;
    
    constructor(address _owner) payable {
        owner = msg.sender;
        emit Deployed(_owner, msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

contract Create2 {
    function deploy(bytes32 _salt) external payable {
        Demo _contract = new Demo
        {
            salt: bytes32(_salt),
            value: msg.value
        }(msg.sender);

        emit Deploy(address(_contract));
    }

    function getByCode(address _owner) public pure returns(bytes memory) {
        bytes memory byteCode = type(Demo).creationCode;
        return abi.encodePacked(byteCode, abi.encode(_owner));
    }

    function getAddress(bytes memory byteCode, uint _salt) public view returns(address) {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0), address(this), _salt, keccak256(byteCode))
        );
        return address(uint160(uint(hash)));
    }
}