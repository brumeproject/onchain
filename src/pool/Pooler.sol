// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { INonfungiblePositionManager } from "./Manager.sol";
import { Timelocked } from "../timelock/Timelocker.sol";

contract Pooler is Timelocked {

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

  function dispose() public onlyOwner timelocked {
      uint256 balance = manager.balanceOf(address(this));

      for (uint256 i = 0; i < balance; i++) {
          uint256 tokenId = manager.tokenOfOwnerByIndex(address(this), i);

          manager.transferFrom(address(this), owner(), tokenId);
      }
  }

  function increaseLiquidity(INonfungiblePositionManager.IncreaseLiquidityParams memory params) public onlyOwner returns (uint128 liquidity, uint256 amount0, uint256 amount1) { 
      if (manager.ownerOf(params.tokenId) != address(this))
          /**
           * Just in case...
           */
          revert();

      return manager.increaseLiquidity(params);
  }

}