// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "./token.sol";
import { Owned } from "./owned.sol";
import { Forwarder } from "./forwarder.sol";

/**
 * An ownable spot in a Harberger-style top-of-the-hill auction
 */
contract Spot is Ownable {

    Token public token;

    constructor(
        Token token_
    )
        Ownable(msg.sender)
    {
        token = token_;
    }

    function acquire(uint256 amount) public {
        uint256 balance = token.balanceOf(address(this));
        
        if (amount < balance)
            revert();

        token.transferFrom(msg.sender, address(this), amount);

        token.transfer(owner(), balance);
        _transferOwnership(msg.sender);
    }

    function withdraw(uint256 amount) public onlyOwner {
        token.transfer(owner(), amount);
    }

}

/**
 * Example contract that puts ads on spots
 */
contract Ads {

    mapping(Owned => string) public ads;

    function publish(Owned owned, string calldata ad) public {
        if (msg.sender != owned.owner())
            revert();
            
        ads[owned] = ad;
    }

}