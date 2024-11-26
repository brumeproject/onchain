// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Tokens {
    
    struct Token {
        uint256 chain;
        address target;
    }

    mapping(address => Token) public registry;

    event Registered(address indexed sender, address indexed target);

    function register(uint256 chain, address target) public {
        registry[msg.sender] = Token(chain, target );
    }

}