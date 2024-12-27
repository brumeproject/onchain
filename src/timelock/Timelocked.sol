// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Timelocked is Ownable {

    /**
     * @dev Absolute timestamp of end-of-lock time
     */
    uint256 public timelock = block.timestamp;

    constructor(
        address owner_
    )
        Ownable(owner_)
    {}

    modifier timelocked() {
        if (block.timestamp < timelock) 
            revert();
            
        _;
    }

    function extend(uint256 updated) public onlyOwner {
        if (updated < timelock) 
            revert();

        timelock = updated;
    }

}