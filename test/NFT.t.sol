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
        contractTested = new NFT();
    }

    function test_function1() public{
        contractTested.fileFuncName();
        assertEq(contractTested.var(), 1);
    }
}