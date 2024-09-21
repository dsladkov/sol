// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./Strings.sol";
import "./IERC721Receiver.sol";

contract ERC721 is IERC721, IERC721Metadata {
  using Strings for uint;
  string private _name;
  string private _symbol;
  mapping (address _owner => uint tokensAmount) private _balances;
  mapping (uint tokenId => address owner) private _owners;
  mapping (uint tokenId => address operator) private _tokenApprovals;
  mapping (address _owner => mapping(address _operator => bool isApproved)) private _operatorApprovals;

  modifier _requireMinted(uint tokenId) {
    require(_exists(tokenId), "not minted");
    _;
  }

  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
  }

  function transferFrom(address from, address to, uint tokenId) external {
    require(_isApprovedOrOwner(msg.sender, tokenId), "not approved or owner");
    _transfer(from, to, tokenId);
  }

  function name() external view returns(string memory){
    return _name;
  }
  function symbol() external view returns(string memory){
    return _symbol;
  }

  //tokenId = 1234
  // ipfs://1234
  //example.com/nft/1234
  function tokenURI(uint tokenId) external view _requireMinted(tokenId) returns(string memory){
    string memory baseURI = _baseURI();
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())): "";
  }

  function balanceOf(address owner) public view returns(uint) {
    require(owner != address(0), "owner cannot be zero");
    return _balances[owner];
  }

  function ownerOf(uint tokenId) external view _requireMinted(tokenId) returns(address) {
    //address _owner =  _owners[tokenId];
    //require(address(_owner) != address(0), "invalid tokenId");
    return _owners[tokenId]; //_owner;
  }

  function approve(address _to, uint _tokenId) external {
    address _owner = this.ownerOf(_tokenId);
    require(_owner == msg.sender || this.isApprovedForAll(_owner, msg.sender), "not an owner");
    require(_to != _owner, "cannot approve to self");
    _tokenApprovals[_tokenId] = _to;
    emit Approval(_owner, _to, _tokenId);
  }

  function setApprovalForAll(address operator, bool approved) external {
    require(msg.sender != operator, "cannot approve to self");
    _operatorApprovals[msg.sender][operator] = approved;

    emit ApprovalForAll(msg.sender, operator, approved);
  }

  function getApproved(uint tokenId) external view _requireMinted(tokenId) returns(address) {
    return _tokenApprovals[tokenId];
  }

  function isApprovedForAll(address owner, address operator) external view returns(bool) {
    require(msg.sender != owner, "cannot approve to self"); //require(msg.sender != operator, "cannot approve to self");
    return _operatorApprovals[owner][operator];
  }

  function _safeMint(address to, uint tokenId) internal virtual {
    _safeMint(to, tokenId, "");
  }

  function _safeMint(address to, uint tokenId, bytes memory data) internal virtual {
    _mint(to, tokenId);
    require(_checkOnERC721Received(address(0), to, tokenId, data), "non-erc721 receiver" );

  }

  function _mint(address to, uint tokenId) internal virtual {
    require(to != address(0), "zero addres to");
    require(!_exists(tokenId), "this tokenId is already minted");

    _beforeTokenTransfer(address(0), to, tokenId);

    _owners[tokenId]= to;
    _balances[to]++;

    emit Transfer(address(0), to, tokenId);

    _afterTokenTransfer(address(0), to, tokenId);
  }

  function burn(uint256 tokenId) public virtual {
    require(_isApprovedOrOwner(msg.sender, tokenId), "not an owner");
    _burn(tokenId);
  }

  function _burn(uint tokenId) internal virtual {
    address owner = this.ownerOf(tokenId);


    _beforeTokenTransfer(owner, address(0), tokenId);
    
    delete _tokenApprovals[tokenId];
    _balances[owner]--;
    delete _owners[tokenId];

    emit Transfer(owner, address(0), tokenId);

    _afterTokenTransfer(owner, address(0), tokenId);
  }

  function _baseURI() internal pure virtual returns(string memory){
    return "";
  }

  function _exists(uint tokenId) internal view returns(bool) {
    return _owners[tokenId] != address(0);
  }

  function _isApprovedOrOwner(address spender, uint tokenId) internal view returns(bool) {
    address owner = this.ownerOf(tokenId);
    return (spender == owner || this.isApprovedForAll(owner, spender) || spender == this.getApproved(tokenId));
  }

  function _safeTransfer(address from, address to, uint tokenId, bytes memory data) internal {
    _transfer(from,to,tokenId);
    require(_checkOnERC721Received(from, to, tokenId, data), "transfer to non-erc721 receiver");
  }

  function _checkOnERC721Received(address from, address to, uint tokenId, bytes memory data) private returns(bool) {
    if(to.code.length > 0) {
      try  IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
        return retval == IERC721Receiver.onERC721Received.selector;
      }
      catch (bytes memory reason) {
        if(reason.length == 0) {
          revert("Transfer to non-erc721 receiver");
        }
        else {
          assembly {
             {
              revert(add(32, reason), mload(reason))
             }
          }
        }
      }
    }
    else {
      return true;
    }
  }

  function _transfer(address from, address to, uint tokenId) internal {
    require(this.ownerOf(tokenId) == from, "incorrect owner");
    require(to != address(0), "to address ti zero!");

    _beforeTokenTransfer(from, to, tokenId);

    delete _tokenApprovals[tokenId];

    _balances[from]++;
    _balances[to]++;
    _owners[tokenId] = to;

    emit Transfer(from, to, tokenId);
    _afterTokenTransfer(from, to, tokenId);
  }

  function safeTransferFrom(address from, address to, uint tokenId) external {
    this.safeTransferFrom(from, to, tokenId, "");
  }

  function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external {
    require(_isApprovedOrOwner(msg.sender, tokenId), "not approved or owner");
    _safeTransfer(from, to, tokenId, data);
  }
  

  function _beforeTokenTransfer(address from, address to, uint tokenId) internal virtual {}
  function _afterTokenTransfer(address from, address to, uint tokenId) internal virtual {}
}