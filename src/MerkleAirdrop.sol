//SPDX-License-Identifier: MIT  

pragma solidity ^0.8.24;

import {IERC20 , SafeERC20 } from "@openzepplin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzepplin/contracts/utils/cryptography/MerkleProof.sol";


contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirDrop_InvalidProof();
    error MerkleAirDrop_AlreadyClaimed();


    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address => bool) private s_hasClaimed;

    event Claim(address indexed account ,  uint256 amount);


    constructor( bytes32 merkleRoot, IERC20 airdropToken ) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;

    }

    function claim(address account , uint256 amount, bytes32[] calldata merkleProof) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirDrop_AlreadyClaimed();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode( account , amount))));

        if (!MerkleProof.verify(merkleProof , i_merkleRoot , leaf)) {
            revert MerkleAirDrop_InvalidProof();
        }

        emit Claim( account , amount);

        i_airdropToken.safeTransfer(account , amount );
        
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }
}


