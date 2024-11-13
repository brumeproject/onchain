// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

/**
 * Any contract with a declared owner
 */
abstract contract Owned {

    /**
     * The owner
     */
    function owner() virtual public returns (address);

}