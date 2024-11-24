// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Contest } from "./contest.sol";
import { Ranking } from "./ranking.sol";

contract Ranker {

    Contest public contest;

    Ranking public ranking;

    constructor(
        Contest contest_,
        Ranking ranking_
    ) {
        contest = contest_;
        ranking = ranking_;
    }

    function rank(address ranked, uint256 start, uint256 end) public view returns (uint256) {
        uint256 attack = contest.getPastVotes(ranked, block.number - 1);

        for (uint256 i = start; i < end; i++) {
            uint256 defense = contest.getPastVotes(ranking.addressOf(i), block.number - 1);

            if (attack < defense)
                continue;

            return i;
        }
        
        revert();
    }

}