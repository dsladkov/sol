import { loadFixture, ethers, expect, time } from "./setup";
import { ArrayReplaceFromEnd } from "../typechain-types";

describe("ArrayreplaceFromEnd", function() {
    async function deploy() {
        const [owner, user1,user2] = await ethers.getSigners();
        const ArrayReplaceFromEnd = await ethers.getContractFactory("ArrayReplaceFromEnd", owner);
        const arrayReplaceFromEnd = await ArrayReplaceFromEnd.deploy();
        await arrayReplaceFromEnd.waitForDeployment();

        return { owner, user1, user2, arrayReplaceFromEnd};
    }

    it("should alllow to replace removing array element by the array last element with pop the latest array element", async () => {
        const {owner, user1, user2, arrayReplaceFromEnd} = await loadFixture(deploy);

        await arrayReplaceFromEnd.push(1);
        await arrayReplaceFromEnd.push(2);
        await arrayReplaceFromEnd.push(3);
        await arrayReplaceFromEnd.push(4);
        await arrayReplaceFromEnd.push(5);

        expect(await arrayReplaceFromEnd.getLength()).to.be.eq(5);

        await arrayReplaceFromEnd.remove(1);
        expect(await arrayReplaceFromEnd.get(1)).to.be.eq(5);
        expect(await arrayReplaceFromEnd.getLength()).to.be.eq(4);
    });

    it("should revert transaction with incorrect index parameter with message out of bound", async() => {
        const {owner, user1, user2, arrayReplaceFromEnd} = await loadFixture(deploy);

        await arrayReplaceFromEnd.push(1);
        await arrayReplaceFromEnd.push(2);
        await arrayReplaceFromEnd.push(3);
        await arrayReplaceFromEnd.push(4);
        await arrayReplaceFromEnd.push(5);

        expect(await arrayReplaceFromEnd.getLength()).to.be.eq(5);
        await expect(arrayReplaceFromEnd.remove(9)).to.be.revertedWith("out of bound");
    })
})