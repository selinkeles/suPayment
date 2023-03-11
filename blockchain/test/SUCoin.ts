import { expect } from 'chai';
import hre from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers"

// test suite (multiple cases) = describe('name', 'test-cb-func')
    // loadFixture = snapshot of state where where fixture is first executed 
    // test-case = it('name', async callback)

describe("SUCoinLocal",  () => {

    // deployAndMintFixture
    async function deployAndMintFixture() {

        // get accounts from local env
        const [ server, kamer, husnu ] = await hre.ethers.getSigners();
        console.log(
            "server: ", server
        )
        
        // deploy (HRE getContractFactory)
        const cf = await hre.ethers.getContractFactory("SUCoin", server);
        cf.connect(server);
        const sucoinContract = await cf.deploy();
    
        // mint to server
        const mint_value = hre.ethers.utils.parseEther("20.0");
        sucoinContract.mint(server.address, mint_value);
    
        // assert minted value
        const exp_val = await sucoinContract.balanceOf(server.address)
        expect(exp_val).to.equal(mint_value);
        
        return { sucoinContract, server, kamer, husnu };
    }
    
    // try: kamer will mint   
    it("non-owner cannot mint", async () => {

        const { sucoinContract, kamer, husnu } = await loadFixture(deployAndMintFixture);
        const mint_value = hre.ethers.utils.parseEther("10.0");
        
        sucoinContract.connect(kamer);
        await expect(sucoinContract.mint(kamer.address, mint_value)).to.be.revertedWith(
            "Ownable: caller is not the owner"
        );

        sucoinContract.connect(husnu);
        await expect(sucoinContract.mint(husnu.address, mint_value)).to.be.revertedWith(
            "Ownable: caller is not the owner"
        );
    });

    it("server increase/decrease allowance", async () => {

        const { sucoinContract, server, kamer, husnu } = await loadFixture(deployAndMintFixture);
        
        const currAllowance = await sucoinContract.allowance(server.address, kamer.address);
        
        const increase_allowance_value = hre.ethers.utils.parseEther("1.0");
        await sucoinContract.increaseAllowance(kamer.address, increase_allowance_value);

        const new_allowance_value = currAllowance.add(increase_allowance_value);
        const result_val = await sucoinContract.allowance(server.address, kamer.address);
        expect(result_val).to.equal(
            new_allowance_value
        );
    });

});