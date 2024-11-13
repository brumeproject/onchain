// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "./token.sol";

/**
 * An ownable spot in a Harberger-style top-of-the-hill auction
 * Withdraw is timelocked to prevent flash-loans or fast-loans
 */
contract Spot is Ownable {

    Token public token;

    uint256 public delay;

    uint256 public timestamp = block.timestamp;

    constructor(
        Token token_,
        uint256 delay_
    )
        Ownable(msg.sender)
    {
        token = token_;
        delay = delay_;
    }

    function acquire(uint256 amount) public {
        uint256 price = token.balanceOf(address(this));
        
        if (amount < price)
            revert();

        token.transferFrom(msg.sender, address(this), amount);

        token.transfer(owner(), price);
        _transferOwnership(msg.sender);

        timestamp = block.timestamp + delay;
    }

    function deposit(uint256 amount) public onlyOwner {
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        if (block.timestamp < timestamp)
            revert();
        token.transfer(owner(), amount);
    }

}

/**
 * Example contract that puts ads on owners
 */
contract Ads {

    mapping(address => string) public ads;

    function publish(string calldata ad) public {
        ads[msg.sender] = ad;
    }

    function retrieve(Spot spot) public view returns (string memory) {
        return ads[spot.owner()];
    }

}