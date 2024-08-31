// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Status} from "./EnumDeclaration.sol";

// Solidity supports enumerables and they are useful to model choice and keep track state
// Enums can be declared outside of a contract
contract Enum {
    // Default value is the first element listed in
    // definition of the type, in this case "Pending"

    Status public status;

    // Returns uint
    // Pending - 0
    // Shipped - 1
    // Accepted - 2
    // Rejected - 3
    // Cancelled - 4

    function get() public view returns(Status) {
        return status;
    }

    // Update status by passing uint into input
    function set(Status _status) public {
        status = _status;
    }

    // You can update to a specific enum like this
    function cancel() public {
        status = Status.Canceled;
    }

    // delete resets the enum to its first value, 0
    function reset() public {
        delete status;
    }
}