// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/math/Math.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

import '../../submodules/marginly/packages/contracts/contracts/dataTypes/Call.sol';
import '../../submodules/marginly/packages/contracts/contracts/dataTypes/Position.sol';
import '../../submodules/marginly/packages/router/contracts/MarginlyRouter.sol';

import '../interfaces/IMarginlyPoolExtended.sol';
import '../interfaces/IMarginlyActions.sol';
import '../poolVerifier/PoolVerifier.sol';
import '../ownership/Ownership.sol';

contract MarginlyActions is IMarginlyActions, PoolVerifier, Ownership {
  constructor(address marginlyFactory, address _owner) PoolVerifier(marginlyFactory) Ownership(_owner) {}

  function depositBase(address marginlyPool, uint256 baseAmount) external onlyOwner {
    verifyPool(marginlyPool);

    address baseToken = IMarginlyPoolExtended(marginlyPool).baseToken();
    TransferHelper.safeTransferFrom(baseToken, msg.sender, address(this), baseAmount);
    TransferHelper.safeApprove(baseToken, marginlyPool, baseAmount);
    IMarginlyPoolExtended(marginlyPool).execute(CallType.DepositBase, baseAmount, 0, 0, false, address(0), 0);
  }

  function depositQuote(address marginlyPool, uint256 quoteAmount) external onlyOwner {
    verifyPool(marginlyPool);

    address quoteToken = IMarginlyPoolExtended(marginlyPool).quoteToken();
    TransferHelper.safeTransferFrom(quoteToken, msg.sender, address(this), quoteAmount);
    TransferHelper.safeApprove(quoteToken, marginlyPool, quoteAmount);
    IMarginlyPoolExtended(marginlyPool).execute(CallType.DepositQuote, quoteAmount, 0, 0, false, address(0), 0);
  }

  function withdrawBase(address marginlyPool, uint256 baseAmount) external onlyOwner {
    verifyPool(marginlyPool);

    address baseToken = IMarginlyPoolExtended(marginlyPool).baseToken();
    IMarginlyPoolExtended(marginlyPool).execute(CallType.WithdrawBase, baseAmount, 0, 0, false, address(0), 0);
    TransferHelper.safeTransfer(baseToken, msg.sender, IERC20(baseToken).balanceOf(address(this)));
  }

  function withdrawQuote(address marginlyPool, uint256 quoteAmount) external onlyOwner {
    verifyPool(marginlyPool);

    address quoteToken = IMarginlyPoolExtended(marginlyPool).baseToken();
    IMarginlyPoolExtended(marginlyPool).execute(CallType.WithdrawQuote, quoteAmount, 0, 0, false, address(0), 0);
    TransferHelper.safeTransfer(quoteToken, msg.sender, IERC20(quoteToken).balanceOf(address(this)));
  }

  function long(
    address marginlyPool,
    uint256 longBaseAmount,
    uint256 limitPriceX96,
    uint256 swapCalldata
  ) external onlyOwner {
    verifyPool(marginlyPool);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.Long,
      longBaseAmount,
      0,
      limitPriceX96,
      false,
      address(0),
      swapCalldata
    );
  }

  function short(
    address marginlyPool,
    uint256 shortBaseAmount,
    uint256 limitPriceX96,
    uint256 swapCalldata
  ) external onlyOwner {
    verifyPool(marginlyPool);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.Short,
      shortBaseAmount,
      0,
      limitPriceX96,
      false,
      address(0),
      swapCalldata
    );
  }

  function closePosition(address marginlyPool, uint256 limitPriceX96, uint256 swapCalldata) external onlyOwner {
    verifyPool(marginlyPool);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.ClosePosition,
      0,
      0,
      limitPriceX96,
      false,
      address(0),
      swapCalldata
    );
  }

  function depositBaseAndLong(
    address marginlyPool,
    uint256 depositBaseAmount,
    uint256 longBaseAmount,
    uint256 limitPriceX96,
    uint256 swapCalldata
  ) external onlyOwner {
    verifyPool(marginlyPool);

    address baseToken = IMarginlyPoolExtended(marginlyPool).baseToken();
    TransferHelper.safeTransferFrom(baseToken, msg.sender, address(this), depositBaseAmount);
    TransferHelper.safeApprove(baseToken, marginlyPool, depositBaseAmount);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.DepositBase,
      depositBaseAmount,
      longBaseAmount,
      limitPriceX96,
      false,
      address(0),
      swapCalldata
    );
  }

  function depositQuoteAndShort(
    address marginlyPool,
    uint256 depositQuoteAmount,
    uint256 shortBaseAmount,
    uint256 limitPriceX96,
    uint256 swapCalldata
  ) external onlyOwner {
    verifyPool(marginlyPool);

    address quoteToken = IMarginlyPoolExtended(marginlyPool).quoteToken();
    TransferHelper.safeTransferFrom(quoteToken, msg.sender, address(this), depositQuoteAmount);
    TransferHelper.safeApprove(quoteToken, marginlyPool, depositQuoteAmount);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.DepositBase,
      depositQuoteAmount,
      shortBaseAmount,
      limitPriceX96,
      false,
      address(0),
      swapCalldata
    );
  }
}
