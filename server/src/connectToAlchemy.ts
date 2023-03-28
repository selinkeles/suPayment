import { Alchemy, Network, Wallet, Contract } from 'alchemy-sdk';
import { NetworkSettings } from './appSettings';

export function connectToRPC(chain: Network) {

    // Network settings
    const networkSettings = new NetworkSettings(chain);
    
    // Alchemy settings
    const settings = {
        apiKey: networkSettings.API_KEY,
        network: chain,
        authToken: networkSettings.AUTH_TOKEN
    };
    const alchemy = new Alchemy(settings);

    // Signer settings
    const wallet = new Wallet(networkSettings.PRIVATE_KEY, alchemy);

    // Contract settings
    const contract = new Contract(networkSettings.CONTRACT_ADDRESS, NetworkSettings.ABI, wallet);

    // print out the variables
    console.log(`
        API_KEY: ${alchemy.config.apiKey}
        WALLET: ${wallet.address}
        CONTRACT_ADDRESS: ${contract.address}
    `)

    return { alchemy, wallet, contract };
}
