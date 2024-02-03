// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import './MarginlyWallet.sol';
import './interfaces/IMarginlyWalletFactory.sol';

contract MarginlyWalletFactory is IMarginlyWalletFactory {
  mapping(address => address) public getWallet;
  address public immutable marginlyFactory;

  constructor(address _marginlyFactory) {
    marginlyFactory = _marginlyFactory;
  }

  function createWallet() external {
    if (getWallet[msg.sender] != address(0)) revert();

    MarginlyWallet wallet = new MarginlyWallet(marginlyFactory, msg.sender);
    getWallet[msg.sender] = address(wallet);

    emit NewWalletCreated(address(wallet), msg.sender);
  }
}
