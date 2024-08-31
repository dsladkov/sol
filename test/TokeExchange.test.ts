import {GuideDAOToken} from "../typechain-types";
import {loadFixture, ethers, expect} from "./setup";
import { withDecimals } from "./helpers";

describe("TokenExchange", function() {
    async function deploy() {
        const [owner, buyer] = await ethers.getSigners();

        const GuideDAOToken = await ethers.getContractFactory("GuideDAOToken");
        const gtk = await GuideDAOToken.deploy(owner.address);
        await gtk.waitForDeployment();

        const TokenExchange = await ethers.getContractFactory("TokenExchange");
        const exch = await TokenExchange.deploy(gtk.target);
        await exch.waitForDeployment();

        return {gtk, exch, owner, buyer};
    }

    it("should allow to buy", async function() {
        const {gtk, exch, owner, buyer} = await loadFixture(deploy);

        const tokensInStock = 3n;
        const tokenWithDecimals = await withDecimals(gtk, tokensInStock);

        const transferTx = await gtk.transfer(exch.target, tokenWithDecimals);
        await transferTx.wait();

        //check taht exch has 3n GuideDAOTokens
        //expect(await gtk.balanceOf(exch.target)).be.to.eq(tokenWithDecimals);
        await expect(transferTx).to.changeTokenBalances(gtk, [owner,exch], [-tokenWithDecimals, tokenWithDecimals]);

        const tokensToBuy = 1n;
        const value = ethers.parseEther(tokensToBuy.toString());

        const buyTx = await exch.connect(buyer).buy({value: value});
        await buyTx.wait();

        await expect(buyTx).to.changeEtherBalances([buyer,exch], [-value, value]);
        await expect(buyTx).to.changeTokenBalances(gtk, [exch,buyer],[-value, value]);
    });

    it("it should allow to sell", async () => {
        const {gtk, exch, owner, buyer} = await loadFixture(deploy);

        const ownedTokens = 2n
        const ownedtokenWithDecimals = await withDecimals(gtk, ownedTokens);

        const transferTx = await gtk.transfer(buyer.address, ownedtokenWithDecimals);
        await transferTx.wait();

        const topUpTx = await exch.topUp({value: ethers.parseEther("5")});
        await topUpTx.wait();

        const tokenToSell = 1n;
        const value = ethers.parseEther(tokenToSell.toString());


        const approveTx = await gtk.connect(buyer).approve(exch.target, value);
        await approveTx.wait();

        const sellTx = await exch.connect(buyer).sell(value);
        await sellTx.wait();

        await expect(sellTx).to.changeEtherBalances([exch,buyer],[-value,value]);
        await expect(sellTx).to.changeTokenBalances(gtk, [exch, buyer], [value, -value]);

    })

    // //this function multiply input value on token exponent power  
    // async function withDecimals(gtk: GuideDAOToken, value: bigint): Promise<bigint> {
    //     return value * 10n ** await gtk.decimals();
    // }
});