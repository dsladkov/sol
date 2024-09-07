import {loadFixture, ethers, expect, time} from "./setup";
import {Crowd} from "../typechain-types";
import { GuideDAOToken } from "../typechain-types";

describe("Crowd", function() {
  async function deploy() {
    const [owner, user1, user2] = await ethers.getSigners();
    const DTK = await ethers.getContractFactory("GuideDAOToken", owner);
    const dtk = await DTK.deploy();
    await dtk.waitForDeployment();

    const Crowd = await ethers.getContractFactory("Crowd", owner);
    const crowd = await Crowd.deploy(dtk.target);
    await crowd.waitForDeployment();

    return {owner, user1, user2, dtk, crowd};
  };

  it("should allow to pledge", async () => {
    const {owner, user1, user2, dtk, crowd} = await loadFixture(deploy);

    const txSendTokens = await dtk.transfer(user1, 1000);

    console.log(`${txSendTokens}`);

  });
})