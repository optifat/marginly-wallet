// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '../../submodules/marginly/packages/contracts/contracts/interfaces/IMarginlyPool.sol';

interface IMarginlyPoolExtended is IMarginlyPool {
  function positions(address owner) external view returns (Position memory);

  function getBasePrice() external view returns (FP96.FixedPoint memory);
}
