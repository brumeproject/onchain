// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Contest } from "./contest.sol";

contract Ranking {

    Contest public contest;

    address[] public addressOf;

    mapping(address => bool) public hasRank;
    mapping(address => uint256) public rankOf;

    constructor(
        Contest contest_
    ) {
        contest = contest_;
    }

    event Claimed(uint256 rank, address winner, address loser);

    function claim(uint256 rank) public {
        address winner = msg.sender;
        address loser = addressOf[rank];

        uint256 attack = contest.getPastVotes(winner, block.number - 1);
        uint256 defense = contest.getPastVotes(loser, block.number - 1);

        if (attack < defense) 
            revert();

        emit Claimed(rank, winner, loser);

        if (hasRank[winner]) 
            addressOf[rankOf[winner]] = address(0);

        rankOf[winner] = rank;
        hasRank[winner] = true;

        addressOf[rank] = winner;

        rankOf[loser] = 0;
        hasRank[loser] = false;
    }

}