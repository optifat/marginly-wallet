// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import './marginlyActions/MarginlyActions.sol';
import './marginlySLTP/MarginlySLTP.sol';

contract MarginlyWallet is MarginlyActions, MarginlySLTP {
  constructor(address marginlyFactory) MarginlyActions(marginlyFactory) MarginlySLTP() {}
}
