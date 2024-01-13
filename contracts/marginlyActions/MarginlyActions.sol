// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@openzeppelin/contracts/access/Ownable2Step.sol';
import '@marginly-contracts/packages/contracts/contracts/interfaces/IMarginlyPool.sol';
import '@marginly-contracts/packages/contracts/contracts/dataTypes/Call.sol';

import '../interfaces/IMarginlyActions.sol';

abstract contract MarginlyActions is IMarginlyActions, Ownable2Step {}
