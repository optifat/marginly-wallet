// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '../interfaces/IMarginlyPoolExtended.sol';
import '../interfaces/ITrigger.sol';

contract SLTP is ITrigger {
  struct SLTPParams {
    uint256 priceX96Low;
    uint256 priceX96High;
  }

  function act(address marginlyPool, bytes calldata _params) external {
    SLTPParams memory params = abi.decode(_params, (SLTPParams));

    IMarginlyPoolExtended marginly = IMarginlyPoolExtended(marginlyPool);

    uint256 currentPrice = marginly.getBasePrice().inner;
    if (currentPrice < params.priceX96High && currentPrice > params.priceX96Low) revert();

    marginly.execute(CallType.ClosePosition, 0, 0, 0, false, address(0), 0);
  }
}
