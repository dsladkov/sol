import { loadFixture, ethers, expect, time } from "./setup";
import { Enum } from "../typechain-types";

describe("Enum", function() {
    async function deploy() {
        const [owner, user1, user2] = await ethers.getSigners();
        const Enum = await ethers.getContractFactory("Enum", owner);
        const myEnum = await Enum.deploy();
        await myEnum.waitForDeployment();
        return {owner, user1, user2, myEnum};
    }

    it("should allow to current status", async() => {
        const {owner, user1, user2, myEnum} = await loadFixture(deploy);

        expect(await myEnum.get()).to.be.eq(0);
    });

    it("should allow to current status", async() => {
        const {owner, user1, user2, myEnum} = await loadFixture(deploy);

        expect(await myEnum.get()).to.be.eq(0);
    });
    it("should allow to set status", async() => {
        const {owner, user1, user2, myEnum} = await loadFixture(deploy);
        await myEnum.set(2);
        expect(await myEnum.get()).to.be.eq(2);
    });
    it("should allow to cancel status", async() => {
        const {owner, user1, user2, myEnum} = await loadFixture(deploy);
        await myEnum.cancel();
        expect(await myEnum.get()).to.be.eq(4);
    });
    it("should allow to reset status", async() => {
        const {owner, user1, user2, myEnum} = await loadFixture(deploy);
        await myEnum.set(2);
        await myEnum.reset()
        expect(await myEnum.get()).to.be.eq(0);
    });
})