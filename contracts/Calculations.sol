// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MultiDelegateCall {
    uint[] public results;


    error NoSuccessTx();

    function multiCall(bytes[] calldata data) external  {
        for(uint i = 0; i < data.length; i++)
        {
            (bool result, bytes memory data) = address(this).delegatecall(data[i]);
            require(result, NoSuccessTx());
            results.push(abi.decode(data, (uint))); //uint(bytes32(data))
        }
    }
}

contract Calculations is MultiDelegateCall {
    event Log(address caller, string calcName, uint result);

    function calc1(uint x, uint y) external returns(uint) {
        uint result = x + y;
        emit Log(msg.sender, "calc1", result);
        return result;
    }

        function calc2(uint x, uint y) external returns(uint) {
        uint result = x * y;
        emit Log(msg.sender, "calc2", result);
        return result;
    }

    function encodeCalc1(uint x, uint y) public pure returns(bytes memory) {
        return abi.encodeWithSelector(Calculations.calc1.selector, x,y);
    }

        function encodeCalc2(uint x, uint y) public pure returns(bytes memory) {
        return abi.encodeWithSelector(Calculations.calc2.selector, x,y);
    }
}

