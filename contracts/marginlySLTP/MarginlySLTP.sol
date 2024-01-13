// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@openzeppelin/contracts/access/Ownable2Step.sol';

import '../interfaces/IMarginlySLTP.sol';

abstract contract MarginlySLTP is IMarginlySLTP, Ownable2Step {}
