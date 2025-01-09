// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "./Token.sol";
import { Timelocked } from "../timelock/Timelocked.sol";

contract Inflator is Timelocked {

    uint256 public constant rate = 3000000000000000;

    Token public immutable token;

    uint256 public timemint;

    constructor(
        Token token_,
        uint256 timemint_
    )
        Timelocked(msg.sender)
    {
        token = token_;
        timemint = timemint_;
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