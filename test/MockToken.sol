// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/ERC20.sol";

contract MockToken is ERC20("Mock", "MOCK") {
    function mint(address _a, uint256 _b) public {
        _mint(_a, _b);
    }
}
