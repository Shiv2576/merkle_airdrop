//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test ,  console} from "lib/forge-std/src/Test.sol";
import { MerkleAirdrop } from "src/MerkleAirdrop.sol";
import {BagelToken} from "src/BagelToken.sol";

contract MerkleAirDropTest is Test {
    MerkleAirdrop public airdrop;
    BagelToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    uint256 AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;


    bytes32[] public PROOF;

    constructor() {
        PROOF.push(0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a);
        PROOF.push(0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576);
    }


    address user;
    uint256 userPrevKey;

    function setUp() public {
        token = new BagelToken();
        airdrop = new MerkleAirdrop( ROOT , token);
        token.mint(token.owner() , AMOUNT_TO_SEND );
        token.transfer( address(airdrop) , AMOUNT_TO_SEND);
        (user , userPrevKey) = makeAddrAndKey("user");
    }


    function testUsersCanClaim() public {
        uint256 initialBalance = token.balanceOf(user);
        vm.prank(user);
        airdrop.claim(user, AMOUNT_TO_CLAIM , PROOF );
        uint256 finalBalance = token.balanceOf(user);

        console.log("Initial balance: %s", initialBalance);
        console.log("Final balance: %s", finalBalance);
        assertEq( finalBalance - initialBalance , AMOUNT_TO_CLAIM);

    }



    
}



