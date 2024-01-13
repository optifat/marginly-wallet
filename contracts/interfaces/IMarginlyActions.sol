// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

interface IMarginlyActions {
  function depositBase(address marginlyPool, uint256 baseAmount) external;

  function depositQuote(address marginlyPool, uint256 quoteAmount) external;

  function withdrawBase(address marginlyPool, uint256 baseAmount) external;

  function withdrawQuote(address marginlyPool, uint256 quoteAmount) external;

  function long(address marginlyPool, uint256 longBaseAmount, uint256 limitPriceX96, uint256 swapCalldata) external;

  function short(address marginlyPool, uint256 shortBaseAmount, uint256 limitPriceX96, uint256 swapCalldata) external;

  function depositBaseAndLong(
    address marginlyPool,
    uint256 depositBaseAmount,
    uint256 longBaseAmount,
    uint256 limitPriceX96,
    uint256 swapCalldata
  ) external;

  function depositQuoteAndShort(
    address marginlyPool,
    uint256 depositQuoteAmount,
    uint256 shortBaseAmount,
    uint256 limitPriceX96,
    uint256 swapCalldata
  ) external;

  function closePosition(address marginlyPool, uint256 limitPriceX96, uint256 swapCalldata) external;

  function flip(address marginlyPool, uint256 limitPriceX96, uint256 swapCalldata) external;
}
