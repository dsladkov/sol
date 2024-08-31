// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    ILogger private _logger;
    mapping(address customer => uint balance) private _balances;

    constructor(address logger_) {
        _logger = ILogger(logger_);
    }

    function deposit() external payable {
        _balances[msg.sender] += msg.value;
        _logger.log(msg.sender, 1);
    }

    function withdraw(uint _amount) external {
        _balances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "can't send");

        _logger.log(msg.sender, 2);
    }
}

interface ILogger {
    event Log(address indexed initiator, uint indexed eventCode);
    function log(address initiator, uint eventCode) external;
}

contract Logger is ILogger {
    function log(address initiator, uint eventCode) external {
        emit Log(initiator, eventCode);
    }
}

contract HoneyPot is ILogger {
    function log(address , uint eventCode) external pure {
        if(eventCode == 2) {
            revert("honeypotted!");
        }
    }
}