// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { INonfungiblePositionManager } from "./Manager.sol";
import { Timelocked } from "../timelock/Timelocker.sol";

contract OldCollector is Ownable {

    /**
     * @dev Uniswap-like v3 position manager
     */
    INonfungiblePositionManager public manager;

    /**
     * @dev Absolute timestamp of end-of-lock time
     */
    uint256 public timestamp = block.timestamp;

    /**
     * @dev You attempted to use something while the contract is locked
     */
    error LockedError(uint256 timestamp);

    /**
     * @dev You provided an invalid absolute timestamp
     */
    error InvalidTimestampError(uint256 timestamp);

    constructor(
        INonfungiblePositionManager manager_
    )
        Ownable(msg.sender)
    {
        manager = manager_;
    }

    function dispose() public onlyOwner {
        if (block.timestamp < timestamp) {
            revert LockedError(block.timestamp);
        }

        uint256 balance = manager.balanceOf(address(this));

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = manager.tokenOfOwnerByIndex(address(this), i);

            manager.transferFrom(address(this), owner(), tokenId);
        }
    }

    function extend(uint256 updated) public onlyOwner {
        if (updated < timestamp) {
            revert InvalidTimestampError(updated);
        }

        timestamp = updated;
    }

    function collect(INonfungiblePositionManager.CollectParams memory params) public onlyOwner returns (uint256 amount0, uint256 amount1) {
        if (params.recipient == address(this)) {
            params.recipient = owner();
        }

        if (params.recipient == address(0)) {
            params.recipient = owner();
        }

        return manager.collect(params);
    }

}

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

  function dispose() public onlyOwner timelocked {
      uint256 balance = manager.balanceOf(address(this));

      for (uint256 i = 0; i < balance; i++) {
          uint256 tokenId = manager.tokenOfOwnerByIndex(address(this), i);

          manager.transferFrom(address(this), owner(), tokenId);
      }
  }

  function collect(INonfungiblePositionManager.CollectParams memory params) public onlyOwner returns (uint256 amount0, uint256 amount1) {
      if (params.recipient == address(this)) {
          params.recipient = owner();
      }

      if (params.recipient == address(0)) {
          params.recipient = owner();
      }

      return manager.collect(params);
  }

}