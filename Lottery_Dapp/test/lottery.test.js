const Lottery = artifacts.require("Lottery");

contract("Lottery", function ([deployer, user1, user2]) {
  let lottery;
  beforeEach(async () => {
    console.log("Before Each");
    lottery = await Lottery.new();
  });

  // 특정 부분만 테스트하고 싶으면 it.only를 적으면 된다
  it.only("getPot should return current pot", async () => {
    let pot = await lottery.getPot();
    assert.equal(pot, 0);
  });
});
