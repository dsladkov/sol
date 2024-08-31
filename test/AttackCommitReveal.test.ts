import { loadFixture,ethers, expect } from "./setup";

describe("Game", function(){
    async function deploy() {
        const [owner] = await ethers.getSigners();

        const secretNumber = 42;
        const salt = ethers.solidityPackedKeccak256(["string"],["owner"]);

        const hashedSecretNumber = await ethers.solidityPackedKeccak256(["address","uint256","bytes32"], [owner.address, secretNumber, salt]);

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy(hashedSecretNumber);
        await game.waitForDeployment();

        return {game, hashedSecretNumber, salt, secretNumber};
    }

    it("commit-reveals", async () => {
        const {game, salt, secretNumber} = await loadFixture(deploy);

        expect(await game.secretNumber()).to.be.eq(0);
        await expect(game.reveal(11,salt)).to.be.revertedWith("invalid reveal!");
        await game.reveal(secretNumber, salt);
        expect(await game.secretNumber()).to.be.eq(secretNumber);

    });
})