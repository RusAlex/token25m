const Token = artifacts.require("Token");

contract("Token", accounts => {
  it("crowdsale should not be fineshed", () =>
    Token.deployed().then(instance => {
      return instance
        .finishCrowdsale()
        .then(() => instance.isCrowdsaleFinished())
        .then(val => assert.equal(val, true))
        .then(() => instance.balanceOf(accounts[0]))
        .then(balance => {
          assert.equal(balance.valueOf(), 28000000 * 10 ** 18, "");
        });
    }));
});
