// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC721Metadata.sol";

contract ERRC721 is IERC721, IERCMetadata {
  string private _name;
  string private _symbol;
}