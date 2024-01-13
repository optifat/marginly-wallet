// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@openzeppelin/contracts/access/Ownable2Step.sol';

import '../../submodules/marginly/packages/contracts/contracts/interfaces/IMarginlyPool.sol';
import '../../submodules/marginly/packages/contracts/contracts/dataTypes/Call.sol';

import '../interfaces/IMarginlySLTP.sol';
import '../poolVerifier/PoolVerifier.sol';

abstract contract MarginlySLTP is IMarginlySLTP, PoolVerifier, Ownable2Step {
  mapping(address => uint256) public getStopLossPrice;
  mapping(address => uint256) public getTakeProfitPrice;

  function setStopLossPrice(address marginlyPool, uint256 priceX96) external onlyOwner {
    verifyPool(marginlyPool);
    getStopLossPrice[marginlyPool] = priceX96;
    emit StopLossPriceSet(marginlyPool, priceX96);
  }

  function setTakeProfitPrice(address marginlyPool, uint256 priceX96) external onlyOwner {
    verifyPool(marginlyPool);
    getTakeProfitPrice[marginlyPool] = priceX96;
    emit TakeProfitPriceSet(marginlyPool, priceX96);
  }

  function closePositionSLTP(address marginlyPool) external {
    uint256 stopLossPrice = getStopLossPrice[marginlyPool];
    uint256 takeProfitPrice = getTakeProfitPrice[marginlyPool];
    if (takeProfitPrice == 0) {
      takeProfitPrice == type(uint256).max;
    }

    uint256 currentBasePrice = 0; //IMarginlyPool(marginlyPool);

    if(currentBasePrice > stopLossPrice && currentBasePrice < takeProfitPrice) {
      revert ();
    }

    // TODO fix args
    IMarginlyPool(marginlyPool).execute(CallType.ClosePosition, 0, 0, 0, false, address(0), 0);
    
    // TODO compensate tx fee
  }

}
