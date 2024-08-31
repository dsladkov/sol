// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForWhileLoop {

    function forLoop(uint _countNum) public pure returns(uint256) {
        uint256 result;
        for(uint256 i = 0; i < _countNum; i++)
        {
            result +=i;
        }
        return result;
    }

    function whileLoop(uint256 _countNum) public pure returns(uint256) {
        uint j;
        uint256 result;
        while(j < _countNum){
            j++;
            result +=j;
        }
        return result;
    }
}