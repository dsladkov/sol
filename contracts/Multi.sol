// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
  address[] public owners;
  mapping(address => bool) public isOwner;

  constructor(address[] memory _owners) {
    require(_owners.length > 0, "no owners!");

    for(uint i; i < _owners.length; i++) {
      address owner = _owners[i];
      require(owner != address(0), "invalid address");
      require(!isOwner[owner], "not unique!");
      owners.push(owner);
      isOwner[owner] = true;
    }
  }

  modifier  onlyOwners() {
    require(isOwner[msg.sender], "not an owner!");
    _;
  }
}

contract MultiSig is Ownable {
  uint public requiredApprovals;

  struct Transaction {
    address _to;
    uint _value;
    bytes _data;
    bool _executed;
  }
  mapping(uint => uint) public approvalsCount;
  mapping(uint => mapping(address => bool)) public approved;

  Transaction[] public transactions;


  event Deposit(address indexed _from, uint _amount);
  event Submit(uint _txId);
  event Approve(address _owner, uint _txId);
  event Revoke(address indexed _owner, uint _txId);
  event Executed(uint _txId, uint _timestamp);

  modifier txExists(uint _txId) {
    require (_txId < transactions.length, "not exists");
    _;
  }

  modifier notApproved(uint _txId) {
    require(!isApproved(_txId, msg.sender), "tx already approved");
    _;
  }

  modifier notExecuted(uint _txId) {
    require(!transactions[_txId]._executed, "executed already");
    _;
  }

  modifier wasApproved(uint _txId) {
    require (isApproved(_txId, msg.sender), "tx wasn't approved yet");
    _;
  }

  modifier enoughApprovals(uint _txId) {
    require(approvalsCount[_txId] >= requiredApprovals, "not enough approvals");
    _;
  }

  function isApproved(uint _txId, address _addr) private view returns(bool) {
    return approved[_txId][_addr];
  }

  constructor(address[] memory _owners, uint _requiredApprovals) Ownable(_owners) {
    require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "invalid approvals count");
    requiredApprovals = _requiredApprovals;
  }

  function submit(address _to, uint _value, bytes calldata _data) external onlyOwners{
    Transaction memory newTx = Transaction({
      _to: _to,
      _value: _value,
      _data: _data,
      _executed: false
    });

    transactions.push(newTx);

    emit Submit(transactions.length - 1);
  }

  function deposit() public payable{
    emit Deposit(msg.sender, msg.value);
  }

  function encode(string memory _func, string memory _arg) public pure returns(bytes memory) {
    return abi.encodeWithSignature(_func, _arg);
  }

  function approve(uint _txId) external onlyOwners txExists(_txId) notApproved(_txId) notExecuted(_txId) {
    approved[_txId][msg.sender] = true;
    approvalsCount[_txId] +=1;

    emit Approve(msg.sender, _txId);
  }

  function revoke(uint _txId) external onlyOwners txExists(_txId) notExecuted(_txId) wasApproved(_txId) {
    approved[_txId][msg.sender] = false;
    approvalsCount[_txId] -=1;

    emit Revoke(msg.sender, _txId);
  }

  function execute(uint _txId) external txExists(_txId) notExecuted(_txId) enoughApprovals(_txId) {
    Transaction storage myTx = transactions[_txId];

    (bool success, ) = myTx._to.call{value: myTx._value}(myTx._data);
    require(success, "tx failed");
    myTx._executed = true;

    emit Executed(_txId, block.timestamp);
  }

  receive() external payable {
    deposit();
  }

}

contract Receiver {
  string public message;

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  function getMoney(string memory _msg) external payable {
    message = _msg;
  }
}