// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Token is ERC20Capped, Ownable, ERC20Burnable {
    using SafeMath for uint256;

    // how many token units a buyer gets per wei
    uint256 public rate = 3500 * 10 ** 18;

    bool crowdSaleFinished = false;
    uint256 start;

    constructor() public ERC20("Grem", "Grm") ERC20Capped(28000000 * (10 ** 18)) {
        // init predefined address distribution
        _mint(msg.sender, 11200000 * 10**18);
        start = now;
    }

    function finishCrowdsale() public onlyOwner  {
        crowdSaleFinished = true;
        uint256 leftOver = 28000000 * 10 ** 18 - totalSupply();
        if (leftOver > 0) {
            _mint(owner(), leftOver);
        }
    }

    function isCrowdsaleFinished() public view returns (bool)  {
        return crowdSaleFinished;
    }

    function updateRate(uint256 _newRate) public onlyOwner {
        rate = SafeMath.mul(_newRate, 10 ** 18);
    }

    // low level token purchase function
    receive() external payable {
        require(msg.sender != address(0));
        require(msg.value >= 1 * 10 ** 18);


        uint256 weiAmount = msg.value;
        // calculate token amount to be created
        // if value > 10 * 10 ** 18
        uint256 tokens = 0;
        if (msg.value < 10 * 10 ** 18) {
            tokens = getTokenAmount(weiAmount);
        } else { // get bonus tokens 10% for amount of >= 1 ETH
            tokens = getTokenAmount(SafeMath.add(weiAmount, SafeMath.div(weiAmount, 10 ** 1)));
        }
        /* uint256 vestingDays = ((start + 90 days) - now) / 60 / 60 / 24; */

        /* if (vestingDays >= 1) { */
        /*     tokens = SafeMath.add(tokens, SafeMath.div(SafeMath.mul(SafeMath.mul(SafeMath.div(tokens,100), 22222222), vestingDays), 10 ** 8)); */
        /* } */

        // mint tokens to owner address
        _mint(owner(), tokens);
        // send purchased token amount and bonuses to payer
        _transfer(owner(), msg.sender, tokens);
        payable(owner()).transfer(msg.value);
    }

    function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        uint256 amount = SafeMath.div(SafeMath.mul(weiAmount, rate), 10 ** 18);
        return amount;
    }

    /**
     * Requirements:
     *
     * crowdsale should be closed now
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        super._beforeTokenTransfer(from, to, amount);

        if (from != address(0) && from != owner()) { // When transferring tokens not minting
            /* require(now > start + 90 days, "Transfers are closed till 90 days since contract deploy date"); */
            require(crowdSaleFinished, "Token: crowdsale is not yet finished");
        }

    }
}
