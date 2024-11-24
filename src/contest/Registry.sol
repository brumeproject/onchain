// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Registry {

    mapping(address => address) public registry;

    event Registered(address indexed sender, address indexed target);

    function register(address target) public {
        registry[msg.sender] = target;
    }

}