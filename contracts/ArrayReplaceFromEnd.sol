// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayReplaceFromEnd {
    uint256[] public arr;

    function get(uint256 _i) public view returns (uint256) {
        return arr[_i];
    }

    function push(uint _i) public {
        //Append to array
        //This will increase the array length by 1.
        arr.push(_i);
    }

    function getLength() public view returns(uint256) {
        return arr.length;
    }

    //Deleting element creates a gap in the array
    // One trick to keep the array compact is to
    // move the last element into the place to delete
    function remove(uint256 _index) public {

        require(_index < arr.length, "out of bound");
        //Move the last element into the place to delete
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }
}