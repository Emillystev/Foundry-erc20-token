// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "OT") {
        _mint(msg.sender, initialSupply);
    }
}
