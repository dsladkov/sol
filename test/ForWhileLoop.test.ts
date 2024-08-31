import { loadFixture, ethers, expect, time } from "./setup";
import { ForWhileLoop } from "../typechain-types";

describe("ForWhileLoop", function() {
    async function deploy() {
        const [owner, user] = await ethers.getSigners();

        const ForWhileLoop = await ethers.getContractFactory("ForWhileLoop", owner);
        const forWhileLoop = await ForWhileLoop.deploy();
        await forWhileLoop.waitForDeployment();
        
        return {owner, user, forWhileLoop};
    }

    it("should allow run forLoop function return sum of elements up to _countNum paramenter", async() => {
        const {owner,user, forWhileLoop} = await loadFixture(deploy);
        const num = 10;
        expect(await forWhileLoop.connect(user).forLoop(num)).to.be.eq(await sumForLoopFunction(num));
    });

    it("should allow run whileLoop function return sum of elements up to _countNum paramenter", async() => {
        const {owner,user, forWhileLoop} = await loadFixture(deploy);
        const num = 10;
        expect(await forWhileLoop.connect(user).whileLoop(num)).to.be.eq(await sumWhileLoopFunction(num));
    });
})

async function sumForLoopFunction(_countNum: number) : Promise<number> {
    let result = 0;
    for(let i = 0; i < _countNum; i++)
    {
        result +=i;
    }
    return result;
}

async function sumWhileLoopFunction(_countNum: number) : Promise<number> {
    let result = 0;
    let j = 0

    while(j < _countNum)
    {   j++;
        result +=j
    }
    return result;
}