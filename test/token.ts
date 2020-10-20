const Token = artifacts.require("Token");

contract("Token", accounts => {
  it("should put 10M Tokens in the first account", () =>
    Token.deployed()
      .then(instance => instance.balanceOf.call(accounts[0]))
      .then(balance => {
        assert.equal(
          balance.valueOf(),
          11200000 * 10 ** 18,
          "On the owner account there are 10M tokens"
        );
      }));

  it("crowdsale should not be fineshed", () =>
    Token.deployed()
      .then(instance => instance.isCrowdsaleFinished())
      .then(val =>
        assert.equal(val, false, "Crowdsale is not finished on init")
      ));

  it("burns successfully", () =>
    Token.deployed().then(instance => {
      return instance
        .balanceOf(accounts[0])
        .then(balance =>
          assert.equal(
            balance.valueOf(),
            11200000 * 10 ** 18,
            "init owner balance is 10M"
          )
        )
        .then(() => instance.burn(web3.utils.toWei(`5000000`)))
        .then(() => instance.balanceOf(accounts[0]))
        .then(
          balance => assert.equal(balance.valueOf(), 6200000 * 10 ** 18),
          "new owner balance is 5M"
        );
    }));

  it("updates rate", () =>
    Token.deployed().then(instance => {
      return instance
        .updateRate(1000)
        .then(() =>
          instance.sendTransaction({ from: accounts[1], value: 1 * 10 ** 18 })
        )
        .then(() => instance.balanceOf(accounts[1]))
        .then(balance =>
          assert.equal(balance.valueOf(), 1000 * 10 ** 18, "Balance of one eth")
        )
        .then(() =>
          instance.sendTransaction({ from: accounts[2], value: 10 * 10 ** 18 })
        )
        .then(() => instance.balanceOf(accounts[2]))
        .then(balance => assert.equal(balance.valueOf(), 11000 * 10 ** 18))
        .then(() => web3.eth.getBalance(accounts[0]))
        .then(ethBalance =>
          assert.isTrue(ethBalance.valueOf() > 11 * 10 ** 18)
        );
    }));
});
