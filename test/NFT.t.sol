// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/*
NOTES:
- to run this contract, 'forge test --match-path test/FILEnAME.t.sol'
- setUp is called again (fresh vars) after each test function
- all tests need to be preceded by 'testXXX'
- all expected to fail tests need to be preceded by 'testFailXXX'
- to get more details; 'forge test --match-path test/Counter.t.sol -vvvvv'
- for gas details; 'forge test --match-path test/Counter.t.sol --gas-report'
*/


import "forge-std/Test.sol";
import "../src/NFT.sol";

contract contractTest is Test {
    NFT public contractTested;

    function setUp() public{
        contractTested = new NFT(
            [   
                "0xcecd463f34f722ce687a5324b6fdd2e1c8fb4e86",
                "0x4d28B3b1A14c90F859675e9c9bFc0852edDd1574",
                "0xC735E150d0562eC7290C16DA74963B41525aC96E"
            ]
        );
    }

    function test_function1() public{
        contractTested.fileFuncName();
        assertEq(contractTested.var1(), 1);
    }
}