// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoEngine {
    address public owner;
    struct ToDo {
        string title;
        string description;
        bool completed;
        
    }

    ToDo[] todos;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you're not an owner!");
        _;
    }

    function addToDo(string calldata _title, string calldata _description) external onlyOwner {
        todos.push(ToDo({
            title: _title,
            description: _description,
            completed: false
        }));
    }

    function changeToDoTitle(string calldata _newTitle, uint256 _index) external onlyOwner {
        todos[_index].title = _newTitle;
    }

    function getToDo(uint256 _index) external view onlyOwner returns(string memory, string memory, bool) {
        ToDo storage myToDo = todos[_index];
        return (
            myToDo.title,
            myToDo.description,
            myToDo.completed
        );
    }

    function inverseToDoStatus(uint256 _index) external onlyOwner {
        todos[_index].completed = !todos[_index].completed;
    }

}