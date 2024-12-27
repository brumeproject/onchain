// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Timelocked } from "./Timelocked.sol";

contract OldTimelocker is Ownable {

    /**
     * @dev Ownable contract to lock ownership of
     */
    Ownable public target;

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
        Ownable target_
    )
        Ownable(msg.sender)
    {
        target = target_;
    }

    function dispose() public onlyOwner {
        if (block.timestamp < timestamp) {
            revert LockedError(block.timestamp);
        }

        target.transferOwnership(owner());
    }

    function extend(uint256 updated) public onlyOwner {
        if (updated < timestamp) {
            revert InvalidTimestampError(updated);
        }

        timestamp = updated;
    }

}

contract Timelocker is Timelocked {

    /**
     * @dev Ownable contract to lock ownership of
     */
    Ownable public target;

    constructor(
        Ownable target_
    )
        Timelocked(msg.sender)
    {
        target = target_;
    }

    function dispose(address to) public onlyOwner timelocked {
        target.transferOwnership(to);
    }

}