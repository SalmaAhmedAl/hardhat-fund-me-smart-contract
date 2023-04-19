const { deployments, ethers, getNamedAccounts } = require("hardhat")
const { assert, expect } = require("chai")

describe("FundMe", async function () {
    let fundMe
    let deployer
    let mockV3Aggregator
    //const sendValue = 1000000000000000000 //1 ETH
    const sendValue = ethers.utils.parseEther("1")

    beforeEach(async function () {
        //deploy our fundMe contract
        //using Hardhat-deploy

        // const accounts = await ethers.getSigners()
        // const accountZero = accounts[0]
        deployer = (await getNamedAccounts()).deployer
        await deployments.fixture(["all"]) //we can deploy the whole folder by this line
        fundMe = await ethers.getContract("FundMe", deployer) //will give us the most recent deployed fund me /// deployer pram to connect deployer with fund me
        mockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )
    })

    describe("constructor", async function () {
        it("sets the aggregator addresses correctly", async function () {
            const response = await fundMe.priceFeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })

    describe("fund", async function () {
        it("Fails if you don't send enough ETH", async function () {
            await expect(fundMe.fund()).to.be.reverted
        })

        it("Updated the amount funded data structure", async function () {
            await fundMe.fund({ value: sendValue })
            // const response = await fundMe.addressToAmountFunded(deployer)
            // assert(response.toString(), sendValue.toString())
        })

        it("Adds funder to array of funders", async function () {
            await fundMe.fund({ value: sendValue })
            const funder = await fundMe.funders(0)
            assert.equal(funder, deployer)
        })
    })
    describe("withDraw", async function () {
        beforeEach(async function () {
            await fundMe.fund({ value: sendValue })
        })

        it("Withdraw ETH from a single funder", async function () {
            //Arrange
            const startingFundMeBalance = await fundMe.provider.getBalance(
                fundMe.address
            ) //We get balance after it's been funded with some ETH
            const startingDeployerBalance = await fundMe.provider.getBalance(
                deployer
            ) //It's going to be of type a big number && big number is an OBJECT
            //Act
            const transactionResponse = await fundMe.withDraw()
            const transactionReceipt = await transactionResponse.wait(1)
            const {gasUsed, effectiveGasPrice}= transactionReceipt
            const gasCost = gasUsed.mul(effectiveGasPrice)
            const endingFundMeBalance = await fundMe.provider.getBalance(
                fundMe.address
            )
            const endingDeployerBalance = await fundMe.provider.getBalance(
                deployer
            )
            //gasCost ...We can get it from transaction receipt
             
            //Assert
            //Now>>We should be able to check to see that the entire fundMe balance has been added to the deployer balance
            assert.equal(endingFundMeBalance, 0)
            assert.equal(
                startingDeployerBalance.add(startingFundMeBalance).toString(),
                endingDeployerBalance.add(gasCost).toString()
            )

        })
    })
})
//We want to make sure that all money went to the right places
