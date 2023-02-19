// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Door3.sol";
import "./MockToken.sol";

contract Door3Test is Test {
    Door3 d3;
    MockToken mt;

    function setUp() public {
        mt = new MockToken();
        d3 = new Door3(address(mt), address(0xabc));
    }

    function testDonate() public {
        mt.mint(address(this), 100e18);
        mt.approve(address(d3), type(uint256).max);

        uint256 beforeE = d3.expiry(address(this));
        uint256 targetExpiry = d3.getNewExpiryTime(address(this), 50e18);
        d3.donate(50e18);
        assertEq(mt.balanceOf(address(0xabc)), 50e18);
        uint256 afterE = d3.expiry(address(this));

        assertGt(afterE, beforeE);
        assertEq(afterE, targetExpiry);

        uint256 targetExpiry2 = d3.getNewExpiryTime(address(this), 22e18);
        d3.donate(22e18);
        assertEq(mt.balanceOf(address(0xabc)), 72e18);
        uint256 afterE2 = d3.expiry(address(this));

        assertEq(targetExpiry2, afterE2);
        assertGt(afterE2, afterE);
    }
}