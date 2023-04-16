// if you a network A use an address Z .... if you a network X use an address Y
const networkConfig = {
 /*THIS IS A CHAINID*/   
    31337: {
        name: "localhost",
    },
    // Price Feed Address, values can be obtained at https://docs.chain.link/data-feeds/price-feeds/addresses
    11155111: {
        name: "sepolia",
        ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
    },
}
//specify which chains are gonna be my development chain
const developmentChains = ["hardhat", "localhost"]
const DECIMALS=8
const INITIAL_ANSWER= 200000000000
module.exports={
    networkConfig,
    developmentChains,
    DECIMALS,
    INITIAL_ANSWER
}