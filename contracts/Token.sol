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

    constructor() public ERC20("Grem", "Grm") ERC20Capped(28000000 * (10 ** 18)) {
        // init predefined address distribution
        _mint(msg.sender, 11200000 * 10**18);
    }

    function finishCrowdSale() public onlyOwner  {
        crowdSaleFinished = true;
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
        uint256 tokens = getTokenAmount(weiAmount);
        // mint tokens to owner address
        _mint(owner(), tokens);
        // send purchased token amount and bonuses to payer
        _transfer(owner(), msg.sender, tokens);
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
            require(!crowdSaleFinished, "Token: crowdsale finished");
        }

    }
}
