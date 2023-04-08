// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/*
NOTES:
- to run this contract, 'forge test --match-path test/FILEnAME.t.sol'
- setUp is called again (fresh vars) after each test function
- all tests need to be preceded by 'testXXX'
- all expected to fail tests need to be preceded by 'testFailXXX'
- to get more details; 'forge test --match-path test/NFT.t.sol -vvvvv'
- for gas details; 'forge test --match-path test/NFT.t.sol --gas-report'
*/


import "forge-std/Test.sol";
import "../src/NFT.sol";

contract contractTest is Test {
    NFT public contractTested;

    function setUp() public{
        address user = address(69);
        vm.startPrank(user);
        
        address[] memory testAddresses = new address[](3);
        testAddresses[0] = address(70);
        testAddresses[1] = address(71);
        testAddresses[2] = address(72);

        contractTested = new NFT(testAddresses);
    }

    function test_initialState() public{
        assertEq(contractTested.totalSupply(), 23);
    }

    function test_mintNormally() public{
        contractTested.flipSaleState();
        contractTested.mint(2);
        assertEq(contractTested.totalSupply(), 25);
    }

    function testFail_mintButSaleNotActive() public{
        contractTested.mint(2);
    }
    
    function testFail_mintSurpassMax() public{
        contractTested.flipSaleState();
        contractTested.mint(11);
    }

}