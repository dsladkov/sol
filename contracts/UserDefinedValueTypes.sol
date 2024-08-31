// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;


//     //Code copied from optimism
//     type Duration is uint64;
//     type Timestamp is uint64;
//     type Clock is uint128;


//     library LibClock {
//         function wrap(Duration _duration, Timestamp _timestamp) internal pure returns (Clock _clock) {
//             assembly {
//                 // data | Duration | Timestamp
//                 // bit  | 0 ... 63 | 63 ... 127
//                 _clock := or(shl(0x40, _duration), _timestamp)
//             }
//         }
//     }
// contract UserDefinedValueTypes {
//     constructor() {
        
//     }
// }