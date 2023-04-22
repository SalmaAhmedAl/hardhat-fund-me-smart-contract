// require("@nomiclabs/hardhat-waffle")
// require("hardhat-gas-reporter")
//require("@nomiclabs/hardhat-ethers")
require("@nomicfoundation/hardhat-toolbox")
// require("@nomiclabs/hardhat-etherscan")
require("dotenv").config()
// require("solidity-coverage")
require("hardhat-deploy")

// require("@nomiclabs/hardhat-waffle")
// require("hardhat-gas-reporter")
// require("@nomiclabs/hardhat-etherscan")
// require("dotenv").config()
// require("solidity-coverage")
// require("hardhat-deploy")


// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
/**
 * @type import('hardhat/config').HardhatUserConfig
 */


const SEPOLIA_RPC_URL = "https://eth-sepolia.g.alchemy.com/v2/3cQUJzAdZHrMRoKunp7noKgiNN8o3b5L"
//process.env.SEPOLIA_RPC_URL ||"https://eth-sepolia/example"
const PRIVATE_KEY ="fcfebbb7539d8e6c69f622e5a3bd5286bcab34b3fd9be64936289f6e602d9184"
//process.env.PRIVATE_KEY || "0xKey"
const ETHERSCAN_API_KEY=process.env.ETHERSCAN_API_KEY || "key"
const COINMARKETCAP_API_KEY=process.env.COINMARKETCAP_API_KEY || "key"

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
  
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 11155111,
      blockConfirmatiions: 6,
  },
    localhost:{
      url:"http://127.0.0.1:8545/",
      chainId: 31337
    }
  },
  solidity: {
    compilers: [
        {
            version: "0.8.7",
        },
        {
            version: "0.6.6",
        },
    ],
},

  etherscan:{
     apiKey: ETHERSCAN_API_KEY
  },

  gasReporter: {
    enabled: true,
    noColors:true,
    currency:"USD",
    outputFile:"gas_report.txt",
    //coinmarketcap:COINMARKETCAP_API_KEY,
    token:"ETH"
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      1: 0 // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
  },
},
  mocha: {
		timeout: 500000,
	},
};
