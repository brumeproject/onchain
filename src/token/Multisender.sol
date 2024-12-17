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