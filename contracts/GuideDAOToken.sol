// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "./ERC20.sol";
import {ERC20Burnable} from "./ERC20Burnable.sol";

contract GuideDAOToken is ERC20, ERC20Burnable {
    address private _owner;

    modifier onlyOwner() {
        require(msg.sender == _owner, "You're not an owner!");
        _;
    }

    constructor(address initialOwner) ERC20("GuideDAOToken", "GTK") {
        _owner = initialOwner;
        mint(msg.sender, 10 * 10 ** decimals());
    }

    function mint(address to, uint256 _amount) public onlyOwner {
        _mint(to, _amount);
    }
}
