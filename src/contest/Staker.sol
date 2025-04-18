// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Wrapper } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

interface Updatable {
    function update(address from, address to, uint256 value) external;
}

/**
 * @dev Staker is a token-wrapper contract that allows users to update their voting power on multiple targets.
 */
contract Staker is Ownable, ERC20, ERC20Wrapper {

    Updatable[] public targets;

    constructor(
        string memory name_,
        string memory symbol_,
        IERC20 token_
    )
        Ownable(msg.sender)
        ERC20(name_, symbol_)
        ERC20Wrapper(token_)
    {}

    /**
     * @dev Update the voting power of all targets.
     */
    function _update(address from, address to, uint256 value) internal override(ERC20) {
        for (uint256 i = 0; i < targets.length; i++) {
            if (address(targets[i]) == address(0))
                continue;
            targets[i].update(from, to, value);
        }

        super._update(from, to, value);
    }

    /**
     * @dev Use ERC20Wrapper decimals.
     */
    function decimals() public view override(ERC20, ERC20Wrapper) returns (uint8) {
        return super.decimals();
    }

    /**
     * @dev Push a target.
     */
    function push(Updatable target) public onlyOwner {
        targets.push(target);
    }

    /**
     * @dev Clear an index.
     */
    function clear(uint256 index) public onlyOwner {
        targets[index] = Updatable(address(0));
    }

    /**
     * @dev Increase your voting power by wrapping `amount` of your original tokens.
     */
    function deposit(uint256 amount) public {
        depositFor(msg.sender, amount);
    }

    /**
     * @dev Increase your voting power by wrapping all your original tokens.
     */
    function depositAll() public {
        depositFor(msg.sender, underlying().balanceOf(msg.sender));
    }

    /**
     * Decrease your voting power by unwrapping `amount` of your original tokens.
     */
    function withdraw(uint256 amount) public {
        withdrawTo(msg.sender, amount);
    }

    /**
     * Decrease your voting power by unwrapping all your original tokens.
     */
    function withdrawAll() public {
        withdrawTo(msg.sender, balanceOf(msg.sender));
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

}