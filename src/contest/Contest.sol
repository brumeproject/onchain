// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Votes, Votes } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contest is a delegate-to-vote contract where voting power is updated by a parent ERC20.
 */
contract Contest is Ownable, ERC20, ERC20Votes {

    constructor(
        string memory name_,
        string memory symbol_,
        IERC20 parent_
    )
        Ownable(address(parent_))
        ERC20(name_, symbol_)
        EIP712("Nevermind", "v1")
    {}

    /**
     * @dev Use ERC20Votes to update the voting power.
     */
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    /**
     * @dev Allow virtual updates from owner.
     */
    function update(address from, address to, uint256 value) public onlyOwner {
        /**
         * @dev Setup account on first deposit.
         */
        if (to != address(0) && balanceOf(to) == 0)
            _mint(to, IERC20(owner()).balanceOf(to));

        /**
         * @dev Setup account on first withdraw.
         */
        if (from != address(0) && balanceOf(from) == 0)
            _mint(from, IERC20(owner()).balanceOf(from));
            
        /**
         * @dev Update the voting power.
         */
        _update(from, to, value);
    }

    /**
     * @dev Disable approvals.
     */
    function approve(address, uint256) public pure override(ERC20) returns (bool) {
        revert();
    }

    /**
     * @dev Disable transfers.
     */
    function transfer(address, uint256) public pure override(ERC20) returns (bool) {
        revert();
    }

    /**
     * @dev Disable transfers.
     */
    function transferFrom(address, address, uint256) public pure override(ERC20) returns (bool) {
        revert();
    }

    /**
     * @dev Disable delegate-by-signature.
     */
    function delegateBySig(
        address,
        uint256,
        uint256,
        uint8,
        bytes32,
        bytes32
    ) public pure override(Votes) {
        revert();
    }

}