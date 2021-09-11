const Lottery = artifacts.require("Lottery");
const assertRevert = require("./assertRevert");
const expectEvent = require("./expectEvent");

contract("Lottery", function ([deployer, user1, user2]) {
  let lottery;
  let betAmount = 5 * 10 ** 15;
  let bet_block_interval = 3;

  beforeEach(async () => {
    lottery = await Lottery.new();
  });

  // 특정 부분만 테스트하고 싶으면 it.only를 적으면 된다
  it("getPot should return current pot", async () => {
    let pot = await lottery.getPot();
    assert.equal(pot, 0);
  });

  describe.only("Bet", function () {
    it("Should Fail when the bet money is not 0.005 ETH", async () => {
      // Fail transaction
      await assertRevert(
        lottery.bet("0xab", { from: user1, value: 4000000000000000 })
      );

      // Transaction object {chainId, value, to, from, gas(Limit), gasPrice}
    });

    it("Should put the bet to the bet queue with 1 bet", async () => {
      // Bet - success?
      let receipt = await lottery.bet("0xab", {
        from: user1,
        value: betAmount,
      });

      let pot = await lottery.getPot();
      assert.equal(pot, 0);

      // Check Contract Balance == 0.005 ETH
      let contractBalance = await web3.eth.getBalance(lottery.address);
      assert.equal(contractBalance, betAmount);

      // Check Bet Info
      let currentBlockNumber = await web3.eth.getBlockNumber();
      let bet = await lottery.getBetInfo(0);

      assert.equal(
        bet.answerBlockNumber,
        currentBlockNumber + bet_block_interval
      );

      assert.equal(bet.bettor, user1);
      assert.equal(bet.challenges, "0xab");

      // Check Log
      // console.log(receipt);
      await expectEvent.inLogs(receipt.logs, "BET");
    });
  });
});
