// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {Token} from "../src/Token.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract TokenTest is Test {
    Token token;
    DeployToken deployToken;

    address bob;
    address alice;

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployToken = new DeployToken();
        token = deployToken.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        vm.prank(address(msg.sender));
        token.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() external {
        assertEq(STARTING_BALANCE, token.balanceOf(bob));
    }

    function testInitialSupply() external {
        assertEq(token.totalSupply(), deployToken.INITIAL_SUPPLY());
    }

    function testUsersCantMint() external {
        vm.expectRevert();
        MintableToken(address(token)).mint(address(this), 1);
    }

    function testAllowances() external {
        uint256 initialAllowance = 1000;

        // bob approves bob to spend tokens on his behalf
        vm.prank(bob);
        token.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount); // we use this function instead of transfer method bc transfer sets the from as whoever is sending the message and for this we need from address to be approved

        assertEq(token.balanceOf(alice), transferAmount);
        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}
