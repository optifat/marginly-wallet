// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

abstract contract TriggerAllowance {
  error Forbidden();

  mapping(address => mapping(address => bytes)) triggerParams;

  function allowTrigger(address trigger, address marginlyPool, bytes calldata params) external {
    triggerParams[trigger][marginlyPool] = params;
  }

  function triggerAction(address marginlyPool, address trigger) external {
    bytes memory params = triggerParams[trigger][marginlyPool];
    if (params.length == 0) revert Forbidden();

    (bool success, bytes memory data) = trigger.delegatecall(
      abi.encodeWithSignature('act(address, bytes)', marginlyPool, params)
    );
  }
}
