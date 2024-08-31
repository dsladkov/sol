import { IfElse } from "../typechain-types";
import { loadFixture, ethers,expect } from "./setup";

describe("IfElse", function () { 
    
    async function deploy() {
    const [owner, user1] = await ethers.getSigners();

    const IfElse = await ethers.getContractFactory("IfElse", owner);
    const ifElse = await IfElse.deploy();
    await ifElse.waitForDeployment();
    return {owner, user1, ifElse};
}

it("should return 0 if number is < than 10", async () => {
    const {owner, user1, ifElse} = await loadFixture(deploy);
    const lessThanTen = 9;
    expect(await ifElse.connect(user1).foo(lessThanTen)).to.be.eq(0);
    expect(await ifElse.connect(user1).ternary(lessThanTen)).to.be.eq(0);
});

it("should return 1 when more than 10 and less than 20", async () => {
    const {owner, user1, ifElse} = await loadFixture(deploy);

    const itLessThanTwentyAndMoreThanTen = 19;
    expect(await ifElse.connect(user1).foo(itLessThanTwentyAndMoreThanTen)).to.be.eq(1);
    expect(await ifElse.connect(user1).ternary(itLessThanTwentyAndMoreThanTen)).to.be.eq(1);
});

it("should return 2 when more than 10 and more than 20", async () => {
    const {owner, user1, ifElse} = await loadFixture(deploy);

    const morethanTwenty = 100;
    expect(await ifElse.connect(user1).foo(morethanTwenty)).to.be.eq(2);
    expect(await ifElse.connect(user1).ternary(morethanTwenty)).to.be.eq(2);
})

});