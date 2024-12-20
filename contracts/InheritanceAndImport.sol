// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustomErrors.sol";
import "./TopParent.sol";
import "./Parent.sol";
import "./Owned.sol";

contract ChildContract is TopParent, Parent, Owned {
    bool public isActive = true;

    modifier isItAlive() {
        require(isActive, Errors.IsDead());
        _;
    }

    function parentFunc() public virtual override(TopParent, Parent) pure returns(uint) {
      return 100;
    }

    function withdrawAllMoney(address payable _to) public isOwner {
        _to.transfer(address(this).balance);
    }

    function DestroyContract(address payable _to) public isOwner isItAlive {
        isActive = false;
        selfdestruct(_to);
    }
}