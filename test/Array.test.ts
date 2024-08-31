import { loadFixture, ethers,expect } from "./setup";
import { Array } from "../typechain-types";

describe("Array", function() {
    async function deploy() {
        const [owner, user1, user2] = await ethers.getSigners();

        const Array = await ethers.getContractFactory("Array", owner);
        const array = await Array.deploy();
        await array.waitForDeployment();

        return {owner, user1, user2, array};
    }
    it("should allow to push element into storage array", async() => {
        const {owner, user1, user2, array} = await loadFixture(deploy);
        const _arrayElementToPush = 100;
        await array.push(_arrayElementToPush);
        expect(await array.get(0)).to.be.eq(_arrayElementToPush);
    });
    it("should allow to get entire array", async () => {
        const {owner, user1, user2, array} = await loadFixture(deploy);
        const _arrayElementToPush = 100;
        await array.push(_arrayElementToPush);

        await array.push(_arrayElementToPush*2);

        expect((await array.connect(user1).getArr()).at(0)).to.be.eq(_arrayElementToPush);
        expect((await array.connect(user1).getArr()).at(1)).to.be.eq(_arrayElementToPush*2);
    });

    it("should allow to decrease the array length. The default value shall be set", async () => {
        const {owner, user1, user2, array} = await loadFixture(deploy);
        const _arrayElementToPush = 100;
        await array.push(_arrayElementToPush);

        await array.push(_arrayElementToPush*2);

        expect((await array.connect(user1).getArr()).at(0)).to.be.eq(_arrayElementToPush);
        expect((await array.connect(user1).getArr()).at(1)).to.be.eq(_arrayElementToPush*2);
        expect((await array.connect(user1).getLength())).to.be.eq(2);
        await array.pop();
        expect((await array.connect(user1).getLength())).to.be.eq(1);
    });
    it("should allow to remove element from an array. The value of the deleted element will have the default value ot the element type", async() =>{
        const {owner, user1, user2, array} = await loadFixture(deploy);
        const _arrayElementToPush = 100;
        await array.push(_arrayElementToPush);

        await array.push(_arrayElementToPush*2);

        expect((await array.connect(user1).getArr()).at(0)).to.be.eq(_arrayElementToPush);
        expect((await array.connect(user1).getArr()).at(1)).to.be.eq(_arrayElementToPush*2);

        await array.remove(1);
        expect(await array.get(1)).to.be.eq(0);
    });
})