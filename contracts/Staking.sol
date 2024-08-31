// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "./ERC20.sol";
import "./ERC20Burnable.sol";

contract StakingToken is ERC20Burnable {
    address private _owner;
    //constructor() ERC20("StakingToken", "ST") {}

    modifier onlyOwner() {
        require(msg.sender == _owner, "You're not an owner!");
        _;
    }

    constructor(address initialOwner, uint _initialAmount) ERC20("StakingToken", "ST") {
        _owner = initialOwner;
        mint(msg.sender, _initialAmount * 10 ** decimals());
    }

    function mint(address to, uint256 _amount) public onlyOwner {
        _mint(to, _amount);
    }
}

