// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "./Token.sol";

contract OldMultisender is Ownable {

    Token public token;

    constructor(
        Token token_
    )
        Ownable(msg.sender)
    {
        token = token_;
    }

    function dispose() public onlyOwner {
        token.transfer(owner(), token.balanceOf(address(this)));
    }

    function send(address[] calldata tos, uint256[] calldata amounts) public onlyOwner {
        for (uint8 i = 0; i < tos.length; i++) {
            token.transfer(tos[i], amounts[i]);
        }
    }

}

contract OldMultiminter is Ownable {

    Token public token;

    constructor(
        Token token_
    )
        Ownable(msg.sender)
    {
        token = token_;
    }

    function dispose() public onlyOwner {
        token.transferOwnership(owner());
    }

    function batch(address[] calldata tos, uint256[] calldata amounts) public onlyOwner {
        for (uint8 i = 0; i < tos.length; i++) {
            token.mint(tos[i], amounts[i]);
        }
    }

}

contract Inflator is Ownable {

    Token public token;

    address public target;

    uint256 public rate = 3000000000000000;

    uint256 public timestamp = block.timestamp;

    constructor(
        Token token_,
        address target_
    )
        Ownable(msg.sender)
    {
        token = token_;
        target = target_;
    }

    function dispose(address to) public onlyOwner {
        token.transferOwnership(to);
    }

    function brrr() public /* EVERYONE! */ {
        uint256 time = block.timestamp - timestamp;

        token.mint(target, time * rate);

        timestamp = block.timestamp;
    }

}