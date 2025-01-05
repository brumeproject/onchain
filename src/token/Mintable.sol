// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Timelocked } from "../timelock/Timelocked.sol";

/**
 * A mintable contract
 */
abstract contract Mintable is Ownable {
    function mint() external virtual;
}

/**
 * A mintable contract with a target parameter
 */
abstract contract ToMintable is Ownable {
    function mint(address to) external virtual;
}

/**
 * Restrict a ToMintable into a Mintable
 */
contract ToMinter is Timelocked {

    ToMintable public mintable;

    address public target;

    constructor(
        ToMintable mintable_,
        address target_
    )
        Timelocked(msg.sender)
    {
        mintable = mintable_;
        target = target_;
    }

    function dispose(address to) public onlyOwner timelocked {
        mintable.transferOwnership(to);
    }

    function mint() public onlyOwner {
        mintable.mint(target);
    }

}

/**
 * Allow a Mintable to everyone
 */
contract SelfMinter is Timelocked {

    Mintable public mintable;

    constructor(
        Mintable mintable_
    )
        Timelocked(msg.sender)
    {
        mintable = mintable_;
    }

    function dispose(address to) public onlyOwner timelocked {
        mintable.transferOwnership(to);
    }

    function mint() public /* EVERYONE */ {
        mintable.mint();
    }

}