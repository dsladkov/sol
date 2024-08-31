import { loadFixture, ethers, expect } from "./setup";

describe("AuctionDenial", function() {
    async function deploy() {
        const [owner, user1, user2, hacker] = await ethers.getSigners();

        const Auction = await ethers.getContractFactory("AuctionDenial");
        const auction = await Auction.deploy();
        await auction.waitForDeployment();


        const hackerAmount = 100;

        const Hack = await ethers.getContractFactory("HackDenial", hacker);
        const hack = await Hack.deploy(auction.target, {value: hackerAmount});
        await hack.waitForDeployment();

        return {auction, hack, owner, user1, user2, hacker, hackerAmount};
    }

    it("allows to hack", async () => {
        const {auction, hack, owner, user1, user2, hacker, hackerAmount} = await loadFixture(deploy);

        const amount1 = ethers.parseEther("3");
        const amount2 = ethers.parseEther("4");

        const bid1 = await auction.connect(user1).bid({value: amount1});
        await bid1.wait();


        const bid2 = await auction.connect(user2).bid({value: amount2});
        await bid2.wait();

        expect(await auction.bids(hack.target)).to.eq(hackerAmount);
        expect(await auction.bids(user1.address)).to.eq(amount1);
        expect(await auction.bids(user2.address)).to.eq(amount2);

        const user1Balance = await ethers.provider.getBalance(user1.address);

        //await expect(auction.refund()).to.be.reverted;

        await auction.refund();

        expect(await ethers.provider.getBalance(user1.address)).to.eq(user1Balance);
    });
});