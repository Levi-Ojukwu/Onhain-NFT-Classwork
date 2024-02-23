import { HardhatUserConfig } from 'hardhat/config';
require("dotenv").config();
// require("@nomiclabs/hardhat-toolkit");
import "@nomicfoundation/hardhat-toolbox";
// require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.20",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
};
