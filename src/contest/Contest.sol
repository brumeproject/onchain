// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Votes } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import { ERC20Wrapper } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import { Votes } from "@openzeppelin/contracts/governance/utils/Votes.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Contest is ERC20, ERC20Wrapper, ERC20Votes {

    constructor(
        string memory name_,
        string memory symbol_,
        IERC20 token_
    )
        ERC20Wrapper(token_)
        ERC20(name_, symbol_)
        EIP712("Nevermind", "v1")
    {}

    /**
     * @dev Use ERC20Wrapper decimals.
     */
    function decimals() public view override(ERC20, ERC20Wrapper) returns (uint8) {
        return super.decimals();
    }

    /**
     * @dev Use ERC20Votes to update the voting power.
     */
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    /**
     * @dev Disable delegate-by-signature to avoid phishing and replay attacks.
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

}