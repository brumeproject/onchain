// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Owned } from "../owning/Owned.sol";

abstract contract Forwarder is Owned {

    address public implementation;

    modifier onlyOwner() {
        if (msg.sender == owner()) {
            _;
        } else {
            revert();
        }
    }

    function setImplementation(address implementation_) external onlyOwner {
        implementation = implementation_;
    }

    function dontcallme() external onlyOwner {
       assembly {
            calldatacopy(0, 0, calldatasize())

            let result := delegatecall(gas(), address(), 0, calldatasize(), 0, 0)

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    function call() internal {
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := call(gas(), sload(implementation.slot), callvalue(), 0, calldatasize(), 0, 0)

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    function staticcall() internal view {
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := staticcall(gas(), sload(implementation.slot), 0, calldatasize(), 0, 0)

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {
        payable(owner()).transfer(msg.value);
    }

    fallback() external payable {
        if (msg.sender == owner()) {
            return call();
        } 

        if (msg.value > 0) {
            revert();
        }

        return staticcall();
    }

}