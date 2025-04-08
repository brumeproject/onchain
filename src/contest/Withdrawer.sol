// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20Votes, Votes } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// TODO: test
contract Withdrawer is Ownable {

    Votes public immutable votes;

    address public immutable signer;
    address public immutable nuller;

    IERC20 public immutable token;

    uint256 public immutable delay;

    mapping(bytes => Request) public requests;

    struct Request {
        uint256 block;
        address target;
        uint256 amount;
        bool withdrawn;
    }

    constructor(
        Votes votes_,
        address signer_,
        address nuller_,
        IERC20 token_,
        uint256 delay_
    )
        Ownable(msg.sender)
    {
      votes = votes_;
      signer = signer_;
      nuller = nuller_;
      token = token_;
      delay = delay_;
    }

    function request(address target, uint256 amount, bytes memory signature) public {
        bytes32 hash = keccak256(abi.encodePacked(target, amount));

        address signer_ = ECDSA.recover(hash, signature);
        
        if (signer_ != signer)
            revert();
        if (requests[signature].withdrawn)
            revert();

        requests[signature] = Request({ block: block.number, target: target, amount: amount, withdrawn: false });
    }

    function withdraw(bytes memory signature) public {
        Request storage request_ = requests[signature];

        if (block.number < (request_.block + delay))
            revert();

        token.transfer(request_.target, request_.amount);

        request_.withdrawn = true;
    }

}