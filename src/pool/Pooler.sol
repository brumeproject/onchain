// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { INonfungiblePositionManager } from "./Manager.sol";
import { Timelocked } from "../timelock/Timelocker.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pooler is Timelocked {

  INonfungiblePositionManager public manager;

  IERC20 public token0;

  IERC20 public token1;

  constructor(
      INonfungiblePositionManager manager_,
      IERC20 token0_,
      IERC20 token1_
  )
      Timelocked(msg.sender)
  {
      manager = manager_;

      token0 = token0_;
      token1 = token1_;

      token0.approve(address(manager), type(uint256).max);
      token1.approve(address(manager), type(uint256).max);
  }

  function dispose(address to) public onlyOwner timelocked {
      token0.transfer(to, token0.balanceOf(address(this)));
      token1.transfer(to, token1.balanceOf(address(this)));
  }
  
  function increaseLiquidity(INonfungiblePositionManager.IncreaseLiquidityParams memory params) public onlyOwner returns (uint128 liquidity, uint256 amount0, uint256 amount1) { 
      return manager.increaseLiquidity(params);
  }

}