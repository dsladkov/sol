import { loadFixture, ethers, expect, time } from "./setup";
import { ArrayRemoveByShifting } from "../typechain-types";

describe("ArrayRemoveByShifting", function() {
    async function deploy(){
        const [owner, user1, user2] = await ethers.getSigners();

        const ArrayRemoveByShifting = await ethers.getContractFactory("ArrayRemoveByShifting", owner);
        const arrayRemoveByShifting = await ArrayRemoveByShifting.deploy();
        await arrayRemoveByShifting.waitForDeployment();

        return {owner, user1, user2, arrayRemoveByShifting};
    }

    it("should allow to insert elements to array and remove them by shifting", async () => {
        const {owner, user1, user2, arrayRemoveByShifting} = await loadFixture(deploy);

        await arrayRemoveByShifting.push(1);
        await arrayRemoveByShifting.push(2);
        await arrayRemoveByShifting.push(3);
        await arrayRemoveByShifting.push(4);
        await arrayRemoveByShifting.push(5);

        expect(await arrayRemoveByShifting.getLength()).to.be.eq(5);

        const tx = await arrayRemoveByShifting.remove(2);
        await tx.wait();
        expect(await arrayRemoveByShifting.arr(2)).to.be.eq(4);

        await arrayRemoveByShifting.remove(0);
        expect(await arrayRemoveByShifting.arr(0)).to.be.eq(2);
    });

    it("should revert transaction with message: index out of bound", async () => {
        const {owner, user1, user2, arrayRemoveByShifting} = await loadFixture(deploy);

        await arrayRemoveByShifting.push(1);
        await arrayRemoveByShifting.push(2);
        await arrayRemoveByShifting.push(3);
        await arrayRemoveByShifting.push(4);
        await arrayRemoveByShifting.push(5);

        await expect(arrayRemoveByShifting.remove(7)).to.be.revertedWith("index out of bound");
    })
})