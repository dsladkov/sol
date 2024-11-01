// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library NumberChecker {
    function isEven(uint _num) internal pure returns(bool) {
        return _num % 2 == 0;
    }
}

contract MyContract {
    uint public myInt;

    function setNum(uint _num) public {
        myInt = _num;
    }

    function isEven() public view returns(bool) {
        return NumberChecker.isEven(myInt);
    }
}