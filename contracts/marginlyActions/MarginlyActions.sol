// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/math/Math.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

import '../../submodules/marginly/packages/contracts/contracts/dataTypes/Call.sol';
import '../../submodules/marginly/packages/contracts/contracts/dataTypes/Position.sol';
import '../../submodules/marginly/packages/router/contracts/MarginlyRouter.sol';

import '../interfaces/IMarginlyPoolExtended.sol';
import '../interfaces/IMarginlyActions.sol';
import '../poolVerifier/PoolVerifier.sol';

contract MarginlyActions is IMarginlyActions, PoolVerifier, Ownable {
  uint24 public constant ONE = 1000000;

  constructor(address marginlyFactory) PoolVerifier(marginlyFactory) {}

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

  function flip(address marginlyPool, uint256 limitPriceX96, uint256 swapCalldata) external onlyOwner {
    verifyPool(marginlyPool);

    PositionType _type = IMarginlyPoolExtended(marginlyPool).positions(address(this))._type;

    MarginlyRouter router = MarginlyRouter(IMarginlyFactory(marginlyFactory).swapRouter());
    // router.swapExactInput(swapCalldata, tokenIn, tokenOut, amountIn, minAmountOut);
  }

  function closeShortWithFlipAndLong(
    address marginlyPool,
    uint256 additionalBaseDeposit,
    uint256 longBaseAmount,
    uint24 slippage,
    uint256 swapCalldata
  ) external onlyOwner {
    verifyPool(marginlyPool);

    MarginlyRouter router = MarginlyRouter(IMarginlyFactory(marginlyFactory).swapRouter());

    address baseToken = IMarginlyPoolExtended(marginlyPool).baseToken();
    address quoteToken = IMarginlyPoolExtended(marginlyPool).quoteToken();
    uint256 currentBasePrice = IMarginlyPoolExtended(marginlyPool).getBasePrice().inner;
    uint256 limitPrice = Math.mulDiv(currentBasePrice, ONE + slippage, ONE);

    {
      Position memory position = IMarginlyPoolExtended(marginlyPool).positions(address(this));

      if (position._type == PositionType.Short) {
        IMarginlyPoolExtended(marginlyPool).execute(
          CallType.ClosePosition,
          0,
          0,
          limitPrice,
          false,
          address(0),
          swapCalldata
        );
      } else if (position._type != PositionType.Lend || position.discountedBaseAmount != 0) {
        revert();
      }
    }

    IMarginlyPoolExtended(marginlyPool).execute(CallType.WithdrawQuote, type(uint256).max, 0, 0, false, address(0), 0);

    uint256 quoteBalance = IERC20(quoteToken).balanceOf(address(this));
    uint256 baseAmount = router.swapExactInput(
      swapCalldata,
      quoteToken,
      baseToken,
      quoteBalance,
      Math.mulDiv(quoteBalance, FP96.Q96, limitPrice)
    );

    if (additionalBaseDeposit != 0) {
      TransferHelper.safeTransferFrom(baseToken, msg.sender, address(this), additionalBaseDeposit);
      baseAmount += additionalBaseDeposit;
    }
    TransferHelper.safeApprove(baseToken, marginlyPool, baseAmount);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.DepositBase,
      baseAmount,
      longBaseAmount,
      limitPrice,
      false,
      address(0),
      swapCalldata
    );
  }

  function closeLongWithFlipAndShort(
    address marginlyPool,
    uint256 additionalQuoteDeposit,
    uint256 shortBaseAmount,
    uint24 slippage,
    uint256 swapCalldata
  ) external onlyOwner {
    verifyPool(marginlyPool);

    MarginlyRouter router = MarginlyRouter(IMarginlyFactory(marginlyFactory).swapRouter());

    address baseToken = IMarginlyPoolExtended(marginlyPool).baseToken();
    address quoteToken = IMarginlyPoolExtended(marginlyPool).quoteToken();
    uint256 currentBasePrice = IMarginlyPoolExtended(marginlyPool).getBasePrice().inner;
    uint256 limitPrice = Math.mulDiv(currentBasePrice, ONE - slippage, ONE);

    {
      Position memory position = IMarginlyPoolExtended(marginlyPool).positions(address(this));

      if (position._type == PositionType.Long) {
        IMarginlyPoolExtended(marginlyPool).execute(
          CallType.ClosePosition,
          0,
          0,
          limitPrice,
          false,
          address(0),
          swapCalldata
        );
      } else if (position._type != PositionType.Lend || position.discountedQuoteAmount != 0) {
        revert();
      }
    }

    IMarginlyPoolExtended(marginlyPool).execute(CallType.WithdrawBase, type(uint256).max, 0, 0, false, address(0), 0);

    uint256 baseBalance = IERC20(baseToken).balanceOf(address(this));
    uint256 quoteAmount = router.swapExactInput(
      swapCalldata,
      baseToken,
      quoteToken,
      baseBalance,
      Math.mulDiv(baseBalance, limitPrice, FP96.Q96)
    );

    if (additionalQuoteDeposit != 0) {
      TransferHelper.safeTransferFrom(quoteToken, msg.sender, address(this), additionalQuoteDeposit);
      quoteAmount += additionalQuoteDeposit;
    }

    TransferHelper.safeApprove(quoteToken, marginlyPool, quoteAmount);
    IMarginlyPoolExtended(marginlyPool).execute(
      CallType.DepositQuote,
      quoteAmount,
      shortBaseAmount,
      limitPrice,
      false,
      address(0),
      swapCalldata
    );
  }
}
