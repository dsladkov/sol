import { expect, ethers, loadFixture } from "./setup";
import { EnglishAuction } from "../typechain-types";

describe("EnglishAuction", function() {
    async function deploy() {
        const [owner, user1, user2] = await ethers.getSigners();
        const EnglishAuction = await ethers.getContractFactory("EnglishAuction", owner);
        const englishAuction = await EnglishAuction.deploy("Magic stone", 1000000);
        await englishAuction.waitForDeployment();


        return{owner, user1, user2, englishAuction};
    }

    it("should allow to start an auction", async () => {
        const {owner, englishAuction} = await loadFixture(deploy);
        await englishAuction.connect(owner).start();

        expect(await englishAuction.connect(owner).started()).to.be.eq(true);
    });

    it("should not allow to start an auction by other than an auction owner", async () => {
        const {owner, user1, user2, englishAuction} = await loadFixture(deploy);
        await expect(englishAuction.connect(user1).start()).to.be.revertedWith("you're not a seller!");
    });

    it("should not allow to bid if an auction is not started yet", async () => {
        const {owner, user1, user2, englishAuction} = await loadFixture(deploy);
        await expect(englishAuction.connect(user1).bid()).to.be.revertedWith("auction isn't started yet!");
    });


    it("should allow to bid if auction is already atarted", async() => {
        const {owner, user1, user2, englishAuction} = await loadFixture(deploy);
        await englishAuction.connect(owner).start();
        const firstBid = 2000000;
        await englishAuction.connect(user1).bid({value: firstBid});
        expect(await englishAuction.highestBid()).to.be.eq(firstBid);
    });


    it("should not allow to bid if current bid is less or equal to the highest auction bit", async() => {
        const {owner, user1, user2, englishAuction} = await loadFixture(deploy);
        await englishAuction.connect(owner).start();
        const firstBid = 2000000;
        await englishAuction.connect(user1).bid({value: firstBid});
        expect(await englishAuction.highestBid()).to.be.eq(firstBid);
        await expect(englishAuction.connect(user2).bid({value: firstBid - 1000})).to.be.revertedWith("your bid isn't more than current bid!");

    });

    it("should not allow to bid if auction is ended yet", async() => {
        const {owner, user1, user2, englishAuction} = await loadFixture(deploy);
        await englishAuction.connect(owner).start();
        const firstBid = 2000000;
        const secondBid = firstBid + 1000000;
        await englishAuction.connect(user1).bid({value: firstBid});
        await englishAuction.connect(owner).end();
        await expect(englishAuction.connect(user2).bid({value: secondBid})).to.be.revertedWith("auction is already ended!");

    });
})