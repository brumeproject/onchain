// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "./Token.sol";
import { Timelocked } from "../timelock/Timelocked.sol";

contract Inflator is Timelocked {

    Token public token;

    uint256 public rate = 3000000000000000;

    uint256 public timemint = 1735689600;

    constructor(
        Token token_
    )
        Timelocked(msg.sender)
    {
        token = token_;
    }

    function dispose(address to) public onlyOwner timelocked {
        token.transferOwnership(to);
    }

    function mint(address to) public onlyOwner {
        uint256 time = block.timestamp - timemint;

        token.mint(to, time * rate);

        timemint = block.timestamp;
    }

}