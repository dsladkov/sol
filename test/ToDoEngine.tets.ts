import { loadFixture, ethers, expect } from "./setup";
import { ToDoEngine } from "../typechain-types";

describe("ToDoEngine", function() {
    async function deploy() {
        const [owner, user1] = await ethers.getSigners();

        const ToDoEngine = await ethers.getContractFactory("ToDoEngine", owner);
        const toDoEngine = await ToDoEngine.deploy();
        await toDoEngine.waitForDeployment();

        return {owner, user1, toDoEngine};
    }

    it("should not allow to run function if not an owner", async () => {
        const {owner, user1, toDoEngine} = await loadFixture(deploy);

        await expect(toDoEngine.connect(user1).addToDo("try to write todo by not an owner", "any description")).to.be.revertedWith("you're not an owner!");
    });

    it("should allow to add todo by the contract owner", async () => {
        const {owner, user1, toDoEngine} = await loadFixture(deploy);

        //const firstToDo = {"first deal", "add first deal into toDoEngine smart contract"};

        await toDoEngine.connect(owner).addToDo("first deal", "add first deal into toDoEngine smart contract");

        const result = await toDoEngine.connect(owner).getToDo(0);
        expect(result[0]).to.be.eq("first deal");
        expect(result[1]).to.be.eq("add first deal into toDoEngine smart contract");
        expect(result[2]).to.be.eq(false);
    });

    it("should inverse status of deal", async () =>{
        const {owner, user1, toDoEngine} = await loadFixture(deploy);

        //const firstToDo = {"first deal", "add first deal into toDoEngine smart contract"};

        await toDoEngine.connect(owner).addToDo("first deal", "add first deal into toDoEngine smart contract");

        await toDoEngine.connect(owner).inverseToDoStatus(0);

        const result = await toDoEngine.connect(owner).getToDo(0);
        expect(result[0]).to.be.eq("first deal");
        expect(result[1]).to.be.eq("add first deal into toDoEngine smart contract");
        expect(result[2]).to.be.eq(true);
    });

    it("should allow to change ttoDo title of deal", async () =>{
        const {owner, user1, toDoEngine} = await loadFixture(deploy);

        //const firstToDo = {"first deal", "add first deal into toDoEngine smart contract"};

        await toDoEngine.connect(owner).addToDo("first deal", "add first deal into toDoEngine smart contract");

        await toDoEngine.connect(owner).changeToDoTitle("New Title for First Deal", 0);

        const result = await toDoEngine.connect(owner).getToDo(0);
        expect(result[0]).to.be.eq("New Title for First Deal");
        expect(result[1]).to.be.eq("add first deal into toDoEngine smart contract");
        expect(result[2]).to.be.eq(false);
    })
})