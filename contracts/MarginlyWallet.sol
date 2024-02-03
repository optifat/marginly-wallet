// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import './marginlyActions/MarginlyActions.sol';

contract MarginlyWallet is MarginlyActions {
  constructor(address marginlyFactory, address owner) MarginlyActions(marginlyFactory, owner) {}
}
