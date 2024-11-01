// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract First {
    function sendMoney(address payable _to) public payable {
        _to.transfer(msg.value);
    }
}

contract Second {
    receive() external payable {}
    fallback() external payable {}

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

contract Third is Second {
    //0xc2985578 - "foo()"
}