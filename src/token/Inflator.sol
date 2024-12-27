// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "./Token.sol";
import { Timelocked } from "../timelock/Timelocked.sol";

contract Inflator is Timelocked {

    Token public token;

    address public target;

    uint256 public rate = 3000000000000000;

    uint256 public timemint = 1735689600;

    constructor(
        Token token_,
        address target_
    )
        Timelocked(msg.sender)
    {
        token = token_;
        target = target_;
    }

    function dispose(address to) public onlyOwner {
        token.transferOwnership(to);
    }

    function mint() public onlyOwner {
        uint256 time = block.timestamp - timemint;

        token.mint(target, time * rate);

        timemint = block.timestamp;
    }

}