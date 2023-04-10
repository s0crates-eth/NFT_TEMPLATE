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
    address public RVLT = 0xf0f9D895aCa5c8678f706FB8216fa22957685A13;

    function setUp() public{

        address user = address(69);
        vm.startPrank(user);

        vm.deal(user, 1_000_000 ether);
        deal(RVLT, user, 1_000_000_000 ether);
        
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
        IERC20(RVLT).approve(address(69), 186900000000000000000000000 * 2);
        contractTested.flipSaleState();
        //contractTested.mint{value: 1 ether}(2);
        //assertEq(contractTested.totalSupply(), 25);
    }

    function testFail_mintButSaleNotActive() public{
        contractTested.mint(2);
    }
    
    function testFail_mintSurpassMax() public{
        contractTested.flipSaleState();
        contractTested.mint(11);
    }

}