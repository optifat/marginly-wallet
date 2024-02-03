// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

contract Ownership {
  address public immutable owner;

  constructor(address _owner) {
    owner = _owner;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}
