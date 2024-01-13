// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

interface IMarginlySLTP {
  event TakeProfitPriceSet(address indexed marginlyPool, uint256 price);

  event StopLossPriceSet(address indexed marginlyPool, uint256 price);

  function getStopLossPrice(address marginlyPool) external view returns (uint256);

  function getTakeProfitPrice(address marginlyPool) external view returns (uint256);

  function setStopLossPrice(address marginlyPool, uint256 priceX96) external;

  function setTakeProfitPrice(address marginlyPool, uint256 priceX96) external;

  function closePositionSLTP(address marginlyPool) external;
}
