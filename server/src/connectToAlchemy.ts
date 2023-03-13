import { Alchemy, Network, Wallet, Contract, AlchemySubscription } from 'alchemy-sdk';
import ABI from '../../blockchain/artifacts/contracts/SUCoin.sol/SUCoin.json';

// Hardcoded variables => to be converted to .env
const API_KEY = "WT9iIsSG05wOTKJWBoGGC9O6ky24UKf7";
const PRIVATE_KEY = "dfb496222786b753eab820acc09d453e06313530e1e03546aa5c49ffcfbd1dcd";
const CONTRACT_ADDRESS = "0x0c46900947843203f0805763dCFAA3A2bC60f145";
const WS_API_URL = "wss://eth-goerli.g.alchemy.com/v2/WT9iIsSG05wOTKJWBoGGC9O6ky24UKf7";
const WH_ID = "wh_k3obqec3wgywmmte";
const WH_AUTH_TOKEN = "_RXj2lZRspHAbBU74dHqDv0khzi1xNvA";
const abi = ABI.abi;

export function connectToRPC() {

    // Alchemy settings
    const settings = {
        apiKey: API_KEY,
        network: Network.ETH_GOERLI,
        authToken: WH_AUTH_TOKEN
    };
    const alchemy = new Alchemy(settings);

    // Signer settings
    const wallet = new Wallet(PRIVATE_KEY, alchemy);

    // Contract settings
    const contract = new Contract(CONTRACT_ADDRESS, abi, wallet);

    // print out the variables
    console.log(`
    API_KEY: ${alchemy.config.apiKey}
    WALLET: ${wallet.address}
    CONTRACT_ADDRESS: ${contract.address}
    `)

    return { alchemy, wallet, contract };
}