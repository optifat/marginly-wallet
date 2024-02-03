// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

interface IMarginlyWalletFactory {
  event NewWalletCreated(address indexed wallet, address indexed owner);

  function getWallet(address user) external view returns (address);

  function createWallet() external;
}
