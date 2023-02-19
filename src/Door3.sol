// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

contract Door3 is Ownable {
    using SafeERC20 for IERC20;

    // Whomst gonna receive all the tokens
    address public benefactory;

    // Address to EPOCH expiry
    mapping(address => uint256) public expiry;

    // Cost to have access to the door, denominated in DAI PER DAY, minimum 1 month payment
    address public token;
    uint256 public tokensPerDay = 6.7e17; // Roughly 20 DAI per 30 days
    uint256 public minDaysPurchased = 30; // Need to purchase 30 days in a row

    constructor(address _token, address _benefactory) {
        token = _token;
        benefactory = _benefactory;
    }

    // **** User entry point ****

    function getNewExpiryTime(address _user, uint256 _amount)
        public
        view
        returns (uint256)
    {
        uint256 prevExpiry = expiry[_user];
        uint256 additionalTime = (_amount * 1 days) / tokensPerDay;

        if (prevExpiry < block.timestamp) {
            return block.timestamp + additionalTime;
        }

        return prevExpiry + additionalTime;
    }

    function getMinDonate() public view returns (uint256) {
        return tokensPerDay * minDaysPurchased;
    }

    // When a user donates it bumps up their expiry
    function donate(uint256 _amount) public {
        require(_amount >= tokensPerDay * minDaysPurchased);
        IERC20(token).safeTransferFrom(msg.sender, benefactory, _amount);

        expiry[msg.sender] = getNewExpiryTime(msg.sender, _amount);
    }

    // **** Owner ****

    function setToken(address _t) public onlyOwner {
        token = _t;
    }

    function setBenefactory(address _b) public onlyOwner {
        benefactory = _b;
    }

    function setTokensPerDay(uint256 _d) public onlyOwner {
        tokensPerDay = _d;
    }

    function setMinDaysPurchased(uint256 _m) public onlyOwner {
        minDaysPurchased = _m;
    }
}
