import { loadFixture, time, expect, ethers } from "./setup";
import { DutchAuction } from "../typechain-types";


describe("DutchAuction", function() {
    async function deploy() {
        const [owner, user1, user2] = await ethers.getSigners();

        const DutchAuction = await ethers.getContractFactory("DutchAuction", owner);
        const stratingPrice = 1000000;
        const discountRate = 2; //10 wei at one second
        const itemName = "Bike";
        const dutchAuction = await DutchAuction.deploy(stratingPrice,discountRate, itemName);
        await dutchAuction.waitForDeployment();

        return {owner, user1, user2, dutchAuction, stratingPrice, discountRate};
    }

    it("should get price is lower than the started price", async() => {
        const {owner, user1, user2, dutchAuction, stratingPrice, discountRate} = await loadFixture(deploy);
        const blockNum = await ethers.provider.getBlockNumber();
        const now = await ethers.provider.getBlock(blockNum);
        
        //await time.setNextBlockTimestamp(now!.timestamp + 24*60*60)
        await time.increaseTo(now!.timestamp + 24*60*60) //24*60*60 it's a one day in seconds
        const result = await dutchAuction.connect(user1).getPrice();
        expect(await dutchAuction.connect(user1).getPrice()).to.be.lessThan(stratingPrice);
        expect(await dutchAuction.connect(user1).getPrice()).to.be.eq(await calculatePriceWithDiscount(discountRate, 24*60*60,stratingPrice));

    });

    it("should allow to buy when auction is not ended yet. After that actuin will be stopped immediately", async () => {
        const {owner, user1, user2, dutchAuction, stratingPrice, discountRate} = await loadFixture(deploy);
        const blockNum = await ethers.provider.getBlockNumber();
        const now = await ethers.provider.getBlock(blockNum);
        await time.increaseTo(now!.timestamp + 24*60*60);

        const ownerAuctionBalancee = await ethers.provider.getBalance(owner);
        const bid = await calculatePriceWithDiscount(discountRate, 24*60*60,stratingPrice) + 1000;
        await dutchAuction.connect(user1).buy({value: bid});
        expect(await dutchAuction.stopped()).to.be.eq(true);
    });

    it("should to send money to the seller when someone bought auction item.", async () => {
        const {owner, user1, user2, dutchAuction, stratingPrice, discountRate} = await loadFixture(deploy);
        const blockNum = await ethers.provider.getBlockNumber();
        const now = await ethers.provider.getBlock(blockNum);
        await time.increaseTo(now!.timestamp + 24*60*60);

        const ownerAuctionBalancee = await ethers.provider.getBalance(owner);
        const bid = await calculatePriceWithDiscount(discountRate, 24*60*60,stratingPrice) + 1000;
        await dutchAuction.connect(user1).buy({value: bid});
        expect(await ethers.provider.getBalance(owner)).to.be.eq(ownerAuctionBalancee + BigInt(await calculatePriceWithDiscount(discountRate, 24*60*60,stratingPrice) - 2));

    });
    it("should not allow to buy when current time is excedeed the action end time", async() => {
        const {owner, user1, user2, dutchAuction, stratingPrice, discountRate} = await loadFixture(deploy);
        const blockNum = await ethers.provider.getBlockNumber();
        const now = await ethers.provider.getBlock(blockNum);
        await time.increaseTo(now!.timestamp + 2*24*60*60);
        await expect(dutchAuction.connect(user1).buy()).to.be.revertedWith("ended");

    });
    it("should not allow to buy if bid is less than auction current price", async() => {
        const {owner, user1, user2, dutchAuction, stratingPrice, discountRate} = await loadFixture(deploy);
        const blockNum = await ethers.provider.getBlockNumber();
        const now = await ethers.provider.getBlock(blockNum);
        await time.increaseTo(now!.timestamp + 24*60*60);
        const bid = await calculatePriceWithDiscount(discountRate, 24*60*60,stratingPrice) - 1000;
        await expect(dutchAuction.connect(user1).buy({value: bid})).to.be.revertedWith("not enough funds.");

    });
});


async function calculatePriceWithDiscount(discountRate: number, timeElapsed: number, startedPrice: number) : Promise<number> {

    return startedPrice - (discountRate * timeElapsed);
}