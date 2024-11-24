// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Contest } from "./contest.sol";

contract Ranking {

    Contest public contest;

    mapping(address => bool) public hasRank;

    mapping(address => uint256) public rankOf;

    mapping(uint256 => address) public addressOf;

    constructor(
        Contest contest_
    ) {
        contest = contest_;
    }

    event Claimed(uint256 indexed rank, address winner, address loser);

    function claim(uint256 rank) public {
        address winner = msg.sender;
        address loser = addressOf[rank];

        if (winner == loser)
            revert();

        uint256 attack = contest.getPastVotes(winner, block.number - 1);
        uint256 defense = contest.getPastVotes(loser, block.number - 1);

        if (attack < defense) 
            revert();

        emit Claimed(rank, winner, loser);

        if (hasRank[winner]) {
            uint256 rank2 = rankOf[winner];

            emit Unclaimed(rank2, winner);

            addressOf[rank2] = address(0);
        }

        rankOf[winner] = rank;
        hasRank[winner] = true;

        addressOf[rank] = winner;

        rankOf[loser] = 0;
        hasRank[loser] = false;
    }

    event Unclaimed(uint256 indexed rank, address loser);

    function unclaim() public {
        if (!hasRank[msg.sender])
            revert();

        uint256 rank = rankOf[msg.sender];

        emit Unclaimed(rank, msg.sender);

        addressOf[rank] = address(0);

        rankOf[msg.sender] = 0;
        hasRank[msg.sender] = false;
    }

}