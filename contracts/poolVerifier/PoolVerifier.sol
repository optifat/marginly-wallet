// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';

import '../../submodules/marginly/packages/contracts/contracts/interfaces/IMarginlyFactory.sol';
import '../../submodules/marginly/packages/contracts/contracts/interfaces/IMarginlyPool.sol';

contract PoolVerifier {
  error WrongMarginlyPoolAddress();

  address public immutable marginlyFactory;
  mapping(address => bool) isPoolVerified;

  constructor(address _marginlyFactory) {
    marginlyFactory = _marginlyFactory;
  }

  function verifyPool(address marginlyPool) internal {
    if (isPoolVerified[marginlyPool]) return;

    IMarginlyPool pool = IMarginlyPool(marginlyPool);
    address baseToken = pool.baseToken();
    address quoteToken = pool.quoteToken();
    uint24 uniswapFee = IUniswapV3Pool(pool.uniswapPool()).fee();

    if (marginlyPool != IMarginlyFactory(marginlyFactory).getPool(quoteToken, baseToken, uniswapFee)) {
      revert WrongMarginlyPoolAddress();
    }

    isPoolVerified[marginlyPool] = true;
  }
}
