import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from 'dotenv'
import { ethers } from "hardhat";

dotenv.config()
const { API_KEY, API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env

const config: HardhatUserConfig = {
  // solidity config
  solidity:{
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  // network config
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      url: `${API_URL}${API_KEY}`,
      accounts: [PRIVATE_KEY??'']
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  }
};

export default config;
