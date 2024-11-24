// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Registry {

    mapping(address => string) public registry;

    function register(string calldata data) public {
        registry[msg.sender] = data;
    }

}