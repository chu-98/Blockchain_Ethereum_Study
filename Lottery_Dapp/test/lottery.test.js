const Lottery = artifacts.require("Lottery");

contract("Lottery", function ([deployer, user1, user2]) {
  let lottery;
  beforeEach(async () => {
    console.log("Before Each");
    lottery = await Lottery.new();
  });

  // 특정 부분만 테스트하고 싶으면 it.only를 적으면 된다
  it("getPot should return current pot", async () => {
    let pot = await lottery.getPot();
    assert.equal(pot, 0);
  });

  describe("Bet", function () {
    it.only("Should Fail when the bet money is not 0.005 ETH", async () => {
      // Fail transaction
      await lottery.bet("0xab", { from: user1, value: 4000000000000000 });

      // Transaction object {chainId, value, to, from, gas(Limit), gasPrice}
    });
    it("Should put the bet to the bet queue with 1 bet", async () => {
      // Bet
      // Check Contract Balance == 0.05 ETH
      // Check Bet Info
      // Check Log
    });
  });
});
