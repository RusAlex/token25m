// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

/*

ERC20 - solidity contract features

- Total supply X amount
- ICO (40% preminted, 60 % for ICO)
- Vesting period X amount, lets say 3 months for now
- ICO stops when 60% of ICO tokens are sold.
- Purchasing token function (X amounts of ETH spent grants X amount of extra tokens), (vesting bonus function in milestone 2, the percentage of bonus tokens is within those 60%, for example, 40% are purchased and 20% is vesting bonus on top of that).
- Burn mechanism
- Source code must be properly commented so that we all can easily read through code and add more functions/change parameters if required.

*/

pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Token is ERC20Capped, Ownable {
    using SafeMath for uint256;

    // how many token units a buyer gets per wei
    uint256 public rate = 1 * 10**18;

    bool crowdSaleFinished = false;

    constructor() public ERC20("Grem", "Grm") ERC20Capped(25000000 * (10 ** 18)) {
        // init predefined address distribution
        _mint(msg.sender, SafeMath.mul(10000000,(10**18)));
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

        uint256 weiAmount = msg.value;
        // calculate token amount to be created
        uint256 tokens = getTokenAmount(weiAmount);
        _mint(owner(), tokens);
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
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        if (from != address(0)) { // When transferring tokens not minting
            require(!crowdSaleFinished, "Token: crowdsale finished");
        }
    }
}
