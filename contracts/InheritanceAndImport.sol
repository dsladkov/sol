// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustomErrors.sol";
import "./Owned.sol";

contract ChildContract is Owned {
    bool public isActive = true;

    modifier isItAlive() {
        require(isActive, Errors.IsDead());
        _;
    }


    function withdrawAllMoney(address payable _to) public isOwner {
        _to.transfer(address(this).balance);
    }

    function DestroyContract(address payable _to) public isOwner isItAlive {
        isActive = false;
        selfdestruct(_to);
    }
}