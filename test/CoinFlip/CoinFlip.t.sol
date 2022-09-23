// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import { CoinFlip } from "../../src/CoinFlip/CoinFlip.sol";
import { CoinFlipHack } from "./CoinFlipHack.sol";
import { SafeMath } from 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol'; 

contract CoinFlipTest is Test {
    using SafeMath for uint256;

    CoinFlip coinflipContract;
    CoinFlipHack coinflipHack;

    address h3x0r = vm.addr(1337);
    address deployer = vm.addr(1);

    uint256 factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() public {
        vm.prank(deployer);
        coinflipContract = new CoinFlip();
    }

    function testCoinFlipHack() public {
        vm.startPrank(h3x0r);
        coinflipHack = new CoinFlipHack(
            address(coinflipContract)
        );
        
        for (uint i; i < 10; i++) {
            coinflipHack.hack();
            // using vm.roll is a bit cheaty
            // find out how to call 10 times without roll
            vm.roll(block.number + 1);
        }
        assertEq(coinflipContract.consecutiveWins(), 10);
    }
}