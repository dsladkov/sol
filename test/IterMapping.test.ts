import { loadFixture, ethers, expect } from "./setup";
import { IterMapping } from "../typechain-types";


describe("IterMapping", function() {
    async function deploy() {
        const [owner, user] = await ethers.getSigners();
        const IterMapping = await ethers.getContractFactory("IterMapping", owner);

        const iterMapping = await IterMapping.deploy();
        await iterMapping.waitForDeployment();

        return{owner, user, iterMapping};
    }

    it("should allow to add key value pair to mapping", async () => {
        const {owner, user, iterMapping} = await loadFixture(deploy);

        const key = "Nastya";
        const age = 40;

        const setTx = await iterMapping.connect(owner).set(key, age);

        await setTx.wait();
        expect(await iterMapping.connect(owner).get(0)).to.be.eq(age);
        expect(await iterMapping.connect(owner).length()).to.be.eq(1);
        expect((await iterMapping.connect(owner).values()).at(0)).to.be.eq(age);
        expect((await iterMapping.connect(owner).getKeys()).length).to.be.eq(1);
        expect(await iterMapping.keys(0)).to.be.eq(key);
        expect(await iterMapping.ages(key)).to.be.eq(age);
        await expect( iterMapping.connect(user).values()).to.be.revertedWith("you're not an owner!");
    })
})