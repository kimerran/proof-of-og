import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

const ONE_DAY_IN_SECONDS = 60 * 60 * 24;

describe("POG", function () {
    async function fixture() {
        // Contracts are deployed using the first signer/account by default
        const [owner, user1, user2] = await ethers.getSigners();

        const POG = await ethers.getContractFactory("POG");
        const cPOG = await POG.deploy();

        return { cPOG, owner };
    }

    describe("Register and claim", function () {
        it("should be able to register and claim", async function () {
            const { cPOG, owner } = await loadFixture(fixture);
            await cPOG.register();

            await time.increaseTo(await time.latest() + ONE_DAY_IN_SECONDS);

            await cPOG.claim();

            let balance = await cPOG.balanceOf(owner.address);
            console.log('balance', balance)

            await cPOG.claim();
            balance = await cPOG.balanceOf(owner.address);
            console.log('balance', balance)
        });
    });
});