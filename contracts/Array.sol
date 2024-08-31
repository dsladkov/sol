// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Solidity Array can hav compile-time fixed size or a dynamic size. 
contract Array {
    //Several ways to initialize an array
    uint256[] public arr;
    uint256[] public arr2 = [1,2,3];
    //Fixed sized array, all elements initialize to default value of type. Fir uint it's a 0
    uint256[10] public myFixedSizedArr;

    function get(uint256 _i) public view returns (uint256) {
        return arr[_i];
    }

    //Solidity can reuturn an entire array.
    //But this function should be avoided for
    //arrays that can grow indefinitely in length.
    function getArr() public view returns(uint256[] memory) {
        return arr;
    }

    function push(uint _i) public {
        //Append to array
        //This will increase the array length by 1.
        arr.push(_i);
    }

    function pop() public {
        //remove last element from array
        //This willl decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns(uint256) {
        return arr.length;
    }

    function remove(uint256 _index) public {
        //Delete does not change the array length
        //It resets the value at the index to it's default value,
        //in this case to 0
        delete arr[_index];
    }

    function examples(uint256 _lengthMemoryArr) external pure{
        //create an array in memory, only fixed size can ve created
        uint256[] memory a = new uint256[](_lengthMemoryArr);
    }


    constructor() {
        
    }
}