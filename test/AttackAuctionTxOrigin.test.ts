import { loadFixture, ethers, expect } from "./setup";

describe("AttackAuctionTxOrigin", function() {
    async function deploy() {
        const [owner, hacker] = await ethers.getSigners();

        const auctionAmount = ethers.parseEther("3");

        const Auction = await ethers.getContractFactory("AttackAuctionTxOrigin", owner);
        const auction = await Auction.deploy({value: auctionAmount});
        await auction.waitForDeployment();


        const HackTxOrigin = await ethers.getContractFactory("HackTxOrigin", hacker);
        const hackTxOrigin = await HackTxOrigin.deploy(auction.target, {value: 500});
        await hackTxOrigin.waitForDeployment();

        return {auction, hackTxOrigin, owner, auctionAmount};
    }

    it("allows to hack", async() => {
        const {auction, hackTxOrigin, owner, auctionAmount} = await loadFixture(deploy);

        //const hackTx = await hackTxOrigin.connect(owner).getYourMoney();
        //await hackTx.wait();

        //expect(hackTx).to.changeEtherBalances([auction, hackTxOrigin], [-auctionAmount, auctionAmount]);
    });
})