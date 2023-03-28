import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from 'dotenv';

dotenv.config();
const { API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

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
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {},
    mumbai: {
      url: `${API_URL}`,
      accounts: [`0x${PRIVATE_KEY}`]
    },
  },

  // etherscan
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },

  // paths
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  }
};

export default config;
