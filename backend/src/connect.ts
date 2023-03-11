import { Alchemy, Network, Wallet, Utils, Contract, AssetTransfersCategory } from 'alchemy-sdk'
import dotenv from 'dotenv'

export async function connect() {
    // env variables
    dotenv.config()
    const { API_KEY, PRIVATE_KEY, CONTRACT_ADDRESS, ABI } = process.env

    // Alchemy settings
    const settings = {
        apiKey: API_KEY,
        network: Network.ETH_GOERLI,
    };
    const alchemy = new Alchemy(settings);

    // Wallet (Signer) settings
    const pk = PRIVATE_KEY ?? "default";
    let wallet = new Wallet(pk , alchemy);

    // Contract settings
    const contract_addr = CONTRACT_ADDRESS ?? "default";
    let abi = ABI ?? "default";
    abi = JSON.parse(abi);
    let contract = new Contract(contract_addr, abi, wallet);

    return { alchemy, wallet, contract }
}


