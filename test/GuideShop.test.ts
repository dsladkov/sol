import { GuideDAOToken, GuideDAOToken__factory } from "../typechain-types";
import { loadFixture, ethers, expect } from "./setup";
import { withDecimals } from "./helpers";

describe("GuideShop", function() {
    async function deploy() {
        const [owner, buyer] = await ethers.getSigners();

        const GuideDAOToken = await ethers.getContractFactory("GuideDAOToken");
        const gtk = await GuideDAOToken.deploy(owner.address);
        await gtk.waitForDeployment();

        const GuideAhop = await ethers.getContractFactory("GuideShop");
        const shop = await GuideAhop.deploy(gtk.target);
        await shop.waitForDeployment();

        return {gtk, shop, owner, buyer};
    }

    it("should allow to buy", async () => {
        const {gtk, shop, owner, buyer} = await loadFixture(deploy);
        
        const transferTx = await gtk.transfer(buyer.address, await withDecimals(gtk, 3n));
        await transferTx.wait();

        const price = 1000n;
        const addTx = await shop.addItem(price,5,"test item");
        await addTx.wait();

        const uid = await shop.uniqueIds(0);
        const deliveryAddress = "demo addr";
        const quantity = 2n;
        const totalPrice = quantity * price;


        const approveTx = await gtk.connect(buyer).approve(shop.target, totalPrice);
        await approveTx.wait();

        const buyTx = await shop.connect(buyer).buy(uid, quantity, deliveryAddress);
        await buyTx.wait();

        await expect(buyTx).to.changeTokenBalances(gtk, [shop,buyer],[totalPrice, -totalPrice]);
        expect(await gtk.allowance(buyer.address,shop.target)).to.be.eq(0);
    });
});