// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { INonfungiblePositionManager } from "./Manager.sol";
import { Timelocked } from "../timelock/Timelocker.sol";

contract Collector is Timelocked {

  /**
   * @dev Uniswap-like v3 position manager
   */
  INonfungiblePositionManager public manager;

  constructor(
      INonfungiblePositionManager manager_
  )
      Timelocked(msg.sender)
  {
      manager = manager_;
  }

  function dispose(address to) public onlyOwner timelocked {
      uint256 balance = manager.balanceOf(address(this));

      for (uint256 i = 0; i < balance; i++) {
          uint256 tokenId = manager.tokenOfOwnerByIndex(address(this), i);

          manager.transferFrom(address(this), to, tokenId);
      }
  }

  function collect(INonfungiblePositionManager.CollectParams memory params) public onlyOwner returns (uint256 amount0, uint256 amount1) {
      return manager.collect(params);
  }

}