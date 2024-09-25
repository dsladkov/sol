// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract Test {
  uint x;

  fallback() external {x = 1;}
}

contract TestPayable {
  uint x;
  uint y;

  fallback() external payable {x = 1; y = msg.value;}

  receive() external payable { x = 2; y = msg.value; }
}


contract Caller {
  function callTest(Test test) public returns (bool) {
    (bool success, ) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
    require(success);


    address payable testPayable = payable(address(test));

    bool successSend = testPayable.send(2 ether);

    return successSend;
  }

  function callTestPayable(TestPayable testPayable) public returns (bool) {
    (bool success, ) = address(testPayable).call(abi.encodeWithSignature(("nonExistingFunction()")));
    require(success);

    (success, ) = address(testPayable).call{value: 2 ether}(abi.encodeWithSignature("nonExistingFunction()"));
    require(success);



    (success,) = address(testPayable).call{value: 2 ether}(""); 
    require(success);
    return true;
  }

  receive() external payable {}
}