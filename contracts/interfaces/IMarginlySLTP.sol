// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

interface IMarginlySLTP {
  function stopLossPrice() external view;

  function takeProfitPrice() external view;

  function setStopLossPrice(address marginlyPool, uint256 price) external;

  function setTakeProfitPrice(address marginlyPool, uint256 price) external;

  function closePositionSLTP(address marginlyPool) external;
}
