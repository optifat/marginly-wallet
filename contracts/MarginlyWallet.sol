// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import './marginlyActions/MarginlyActions.sol';
import './triggerAllowance/TriggerAllowance.sol';

contract MarginlyWallet is MarginlyActions, TriggerAllowance {
  constructor(address marginlyFactory, address owner) MarginlyActions(marginlyFactory, owner) {}
}
