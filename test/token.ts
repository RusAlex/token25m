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
    Token.deployed().then(instance =>
      instance
        .updateRate(1000)
        .then(() =>
          instance.sendTransaction({ from: accounts[1], value: 1 * 10 ** 18 })
        )
        .then(() => instance.balanceOf(accounts[1]))
        .then(balance => assert.equal(balance.valueOf(), 1000 * 10 ** 18))
    ));

  // it("should call a function that depends on a linked library", () => {
  //   let meta;
  //   let metaCoinBalance;
  //   let metaCoinEthBalance;

  //   return MetaCoin.deployed()
  //     .then(instance => {
  //       meta = instance;
  //       return meta.getBalance.call(accounts[0]);
  //     })
  //     .then(outCoinBalance => {
  //       metaCoinBalance = outCoinBalance.toNumber();
  //       return meta.getBalanceInEth.call(accounts[0]);
  //     })
  //     .then(outCoinBalanceEth => {
  //       metaCoinEthBalance = outCoinBalanceEth.toNumber();
  //     })
  //     .then(() => {
  //       assert.equal(
  //         metaCoinEthBalance,
  //         2 * metaCoinBalance,
  //         "Library function returned unexpected function, linkage may be broken"
  //       );
  //     });
  // });

  // it("should send coin correctly", () => {
  //   let meta;

  //   // Get initial balances of first and second account.
  //   const account_one = accounts[0];
  //   const account_two = accounts[1];

  //   let account_one_starting_balance;
  //   let account_two_starting_balance;
  //   let account_one_ending_balance;
  //   let account_two_ending_balance;

  //   const amount = 10;

  //   return MetaCoin.deployed()
  //     .then(instance => {
  //       meta = instance;
  //       return meta.getBalance.call(account_one);
  //     })
  //     .then(balance => {
  //       account_one_starting_balance = balance.toNumber();
  //       return meta.getBalance.call(account_two);
  //     })
  //     .then(balance => {
  //       account_two_starting_balance = balance.toNumber();
  //       return meta.sendCoin(account_two, amount, { from: account_one });
  //     })
  //     .then(() => meta.getBalance.call(account_one))
  //     .then(balance => {
  //       account_one_ending_balance = balance.toNumber();
  //       return meta.getBalance.call(account_two);
  //     })
  //     .then(balance => {
  //       account_two_ending_balance = balance.toNumber();

  //       assert.equal(
  //         account_one_ending_balance,
  //         account_one_starting_balance - amount,
  //         "Amount wasn't correctly taken from the sender"
  //       );
  //       assert.equal(
  //         account_two_ending_balance,
  //         account_two_starting_balance + amount,
  //         "Amount wasn't correctly sent to the receiver"
  //       );
  //     });
  // });
});
