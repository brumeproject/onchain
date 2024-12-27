// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { INonfungiblePositionManager } from "./Manager.sol";
import { Timelocked } from "../timelock/Timelocker.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pooler is Timelocked {

  /**
   * @dev Uniswap-like v3 position manager
   */
  INonfungiblePositionManager public manager;

  /**
   * @dev Only for proper disposal, order doesn't matter
   */
  IERC20 public token0;

  /**
   * @dev Only for proper disposal, order doesn't matter
   */
  IERC20 public token1;

  constructor(
      INonfungiblePositionManager manager_
  )
      Timelocked(msg.sender)
  {
      manager = manager_;
  }

  function dispose(address to) public onlyOwner timelocked {
      token0.transfer(to, token0.balanceOf(address(this)));
      token1.transfer(to, token1.balanceOf(address(this)));

      uint256 balance = manager.balanceOf(address(this));

      for (uint256 i = 0; i < balance; i++) {
          uint256 tokenId = manager.tokenOfOwnerByIndex(address(this), i);

          manager.transferFrom(address(this), to, tokenId);
      }
  }

  /**
   * @dev Owner MAY NEED to verify that the liquidity is not sent to a unowned pool
   */
  function increaseLiquidity(INonfungiblePositionManager.IncreaseLiquidityParams memory params) public onlyOwner returns (uint128 liquidity, uint256 amount0, uint256 amount1) { 
      return manager.increaseLiquidity(params);
  }

}