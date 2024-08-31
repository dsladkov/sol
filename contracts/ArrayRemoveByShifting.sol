// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Remove array element by shifting elements from right to left
contract ArrayRemoveByShifting {
    //[1, 2, 3] --> remove() --> [1,3,3] --> [1,3]

    uint256[] public arr;

    function push(uint _i) public {
        //Append to array
        //This will increase the array length by 1.
        arr.push(_i);
    }

    function getLength() public view returns(uint256) {
        return arr.length;
    }

    function remove(uint256 _index) public {
        require(_index < arr.length, "index out of bound");

        for(uint256 i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[_index + 1];
        }
        arr.pop();
    }
}