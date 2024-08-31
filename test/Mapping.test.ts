import { loadFixture, ethers, expect } from "./setup";
import { Mapping, NestedMapping } from "../typechain-types";


describe("Mapping", function() {
    async function deploy() {
        const [owner, user1, user2] = await ethers.getSigners();

        const Mapping = await ethers.getContractFactory("Mapping", owner);
        const mapping = await Mapping.deploy();
        await mapping.waitForDeployment();

        return {owner, user1, user2, mapping};
    }

    it("should possible to initialize mapping some values.", async() => {
        const {owner, user1, user2, mapping} = await loadFixture(deploy);

        let result = await mapping.set(owner.address, 1);
        result.wait();
        result = await mapping.set(user1.address, 2);
        result.wait();
        result = await mapping.set(user2.address, 3);
        result.wait();
        
        expect(await mapping.get(owner.address)).to.be.eq(1);
        expect(await mapping.get(user1.address)).to.be.eq(2);
        expect(await mapping.get(user2.address)).to.be.eq(3);
    });

    it("should allow to remove value from mapping", async() => {
        const {owner, user1, user2, mapping} = await loadFixture(deploy);

        let result = await mapping.set(owner.address, 1);
        result.wait();
        result = await mapping.set(user1.address, 2);
        result.wait();
        result = await mapping.set(user2.address, 3);
        result.wait();
        
        expect(await mapping.get(owner.address)).to.be.eq(1);
        expect(await mapping.get(user1.address)).to.be.eq(2);
        expect(await mapping.get(user2.address)).to.be.eq(3);

        result = await mapping.remove(owner.address);
        result.wait();
        result = await mapping.remove(user1.address);
        result.wait();
        result = await mapping.remove(user2.address);
        result.wait();
        
        expect(await mapping.get(owner.address)).to.be.eq(0);
        expect(await mapping.get(user1.address)).to.be.eq(0);
        expect(await mapping.get(user2.address)).to.be.eq(0);
    })
});

describe("Nested Mapping", function() {
    async function deploy(){
        const [owner, user1, user2] = await ethers.getSigners();

        const NestedMapping = await ethers.getContractFactory("NestedMapping", owner);
        const nestedMapping = await NestedMapping.deploy();
        await nestedMapping.waitForDeployment();

        return{owner, user1, user2, nestedMapping};
    }
    it("should allow to initialize nested mapping", async () => {
        const {owner, user1, user2, nestedMapping} = await loadFixture(deploy);

        let result = await nestedMapping.set(owner.address, 7, true);
        result.wait();
        result = await nestedMapping.set(user1.address, 8, true);
        result.wait();
        result = await nestedMapping.set(user2.address, 9, true);
        result.wait();
        
        expect(await nestedMapping.get(owner.address, 7)).to.be.true;
        expect(await nestedMapping.get(user1.address, 8)).to.be.true;
        expect(await nestedMapping.get(user2.address, 9)).to.be.true;
    });

    it("should allow to remove from nested mapping", async () => {
        const {owner, user1, user2, nestedMapping} = await loadFixture(deploy);

        let result = await nestedMapping.set(owner.address, 7, true);
        result.wait();
        result = await nestedMapping.set(user1.address, 8, true);
        result.wait();
        result = await nestedMapping.set(user2.address, 9, true);
        result.wait();
        
        expect(await nestedMapping.get(owner.address, 7)).to.be.true;
        expect(await nestedMapping.get(user1.address, 8)).to.be.true;
        expect(await nestedMapping.get(user2.address, 9)).to.be.true;


        result = await nestedMapping.remove(owner.address, 7);
        result.wait();
        result = await nestedMapping.remove(user1.address, 8);
        result.wait();
        result = await nestedMapping.remove(user2.address, 9);
        result.wait();
        
        expect(await nestedMapping.get(owner.address, 7)).to.be.false;
        expect(await nestedMapping.get(user1.address, 8)).to.be.false;
        expect(await nestedMapping.get(user2.address, 9)).to.be.false;
    });
});