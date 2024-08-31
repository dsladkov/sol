// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timelock {
    address public owner;
    uint public constant MIN_DELAY = 10; //just for development 10 seconds. It usually takes more than several days
    uint public constant MAX_DEALY = 100;
    uint public constant EXPIRY_DELAY = 1000;

    event Queued(bytes32 indexed _txId, address indexed _to, uint _value, string indexed _func, bytes _data, uint _timestamp);
    event Executed(bytes32 indexed _txId, address indexed _to, uint _value, string indexed _func, bytes _data, uint _timestamp);

    mapping(bytes32 transactinIdentifier => bool isQueued) queuedTx;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You're not an owner!");
        _;
    }

    function queue(address _to, uint _value, string calldata _func, bytes calldata _data,  uint _timestamp) external onlyOwner returns(bytes32) {
        bytes32 txId = keccak256(abi.encode(_to, _value, _func, _data, _timestamp));
        require(!queuedTx[txId], "already queued!");
        require(_timestamp >= block.timestamp + MIN_DELAY && _timestamp <= block.timestamp + MAX_DEALY, "invalid timestamp");
        emit Queued(txId, _to, _value, _func, _data, _timestamp);

        return txId;
    } 

    function execute(address _to, uint _value, string calldata _func, bytes calldata _data,  uint _timestamp) external payable onlyOwner returns(bytes memory) {
        bytes32 txId = keccak256(abi.encode(_to, _value, _func, _data, _timestamp));
        require(queuedTx[txId], "not queued!");
        require(block.timestamp >= _timestamp, "too early");
        require(block.timestamp <= _timestamp + EXPIRY_DELAY, "too late");
        
        delete queuedTx[txId]; //delete transaction from mapping

        bytes memory data;
        if(bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }

        (bool success, bytes memory resp) = _to.call{value: _value}(data);

        require(success, "tx failed!");
        
        emit Executed(txId, _to, _value, _func, _data, _timestamp);
        return resp;
    }

    function cancel(bytes32 _txId) external onlyOwner {
        require(!queuedTx[_txId], "already queued!");
        delete queuedTx[_txId]; //delete transaction from mapping
    }
}

contract Runner {
    address public lock;
    string message;
    mapping(address => uint) public payments;

    constructor(address _lock) {
        lock = _lock;
    }

    function run(string memory _newMsg) external payable {
        require(msg.sender == lock, "invalid address!");
        payments[msg.sender] += msg.value;
        message = _newMsg;
    }

    function newTimestamp() external view returns(uint) {
        return block.timestamp + 20;
    }

    function prepeareData(string calldata _msg) external pure returns(bytes memory) {
        return abi.encode(_msg);
    }
}