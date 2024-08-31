import { loadFixture, ethers, expect } from "./setup";
import type { Bank, HoneyPot } from "../typechain-types";

describe("HonePotAttack", function() {
    async function deploy() {
        const HoneyPotFactory = await ethers.getContractFactory("HoneyPot");
        const honeypot = await HoneyPotFactory.deploy()
        await honeypot.waitForDeployment()

        const BankFactory = await ethers.getContractFactory("Bank");
        const bank = await BankFactory.deploy(honeypot.target);
        await bank.waitForDeployment();

        const [user1,user2] = await ethers.getSigners();

        return {honeypot, bank, user1, user2};
    }

    it("shouldn't revert funds from the bank with honeypot", async () => {
        
        const {honeypot, bank, user1, user2} = await loadFixture(deploy);
        const user1Balance = await ethers.provider.getBalance(user1.address);

        const _amount = 1000000;

        const depositTx = await bank.connect(user1).deposit({value: _amount});
        await depositTx.wait();

        await expect(bank.connect(user1).withdraw(_amount)).to.be.revertedWith("honeypotted!");

    });
})