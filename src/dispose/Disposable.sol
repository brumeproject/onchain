// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Disposable {
    function dispose() external virtual;
}

abstract contract ToDisposable {
    function dispose(address to) external virtual;
}

/**
 * Allow disposal to a call-time address
 */
contract Acquirer is Ownable {

    Disposable public disposable;

    Ownable public ownable;

    constructor(
        Disposable disposable_,
        Ownable ownable_
    )
        Ownable(msg.sender)
    {
        disposable = disposable_;
        ownable = ownable_;
    }

    function dispose(address to) public onlyOwner {
        /**
         * Acquire ownership
         */
        disposable.dispose();

        /**
         * Transfer ownership
         */
        ownable.transferOwnership(to);
    }

}

/**
 * Restrict disposal to a compile-time address
 */
contract Restricter is Ownable {

    ToDisposable public disposable;

    address public to;

    constructor(
        ToDisposable disposable_,
        address to_
    )
        Ownable(msg.sender)
    {
        disposable = disposable_;
        to = to_;
    }

    function dispose() public onlyOwner {
        disposable.dispose(to);
    }

}