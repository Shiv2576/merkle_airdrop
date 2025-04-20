//SPDX-Licencee-Identifier: MIT

pragma solidity ^0.8.24;

import {Script , console} from "lib/forge-std/src/Script.sol";
import { DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";

contract ClaimAirdrop is Script {
    address  Claiming_Address = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 Claiming_Amount = 25 * 1e18;    
    bytes32 proof_One = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 proof_Two = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [proof_One , proof_Two];

    bytes private SIGNATURE = hex"e145f02290325f37c9117f141c1b60de5873d3f151452583066ce9a0d411065c6d996733f223f016020a5f0d5d4d015cd61f9fdd5f4e264d1a4f0466e5463ca31c";


    error ClaimAirdrop_InvalidSignature();


    function claimAirdrop(address airdrop) public {
        vm.startBroadcast();
        (uint8 v ,  bytes32 r , bytes32 s) = splitSignature(SIGNATURE);
        console.log("Claiming Airdrop");
        MerkleAirdrop(airdrop).claim(Claiming_Address , Claiming_Amount , proof , v , r , s);
        vm.stopBroadcast();
        console.log("Claimed Airdrop");
    }


    function splitSignature(bytes memory sig) public pure returns (uint8 v , bytes32 r , bytes32 s) {
        require(sig.length == 65, "Invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop" , block.chainid);
        claimAirdrop(mostRecentlyDeployed);
    }
}