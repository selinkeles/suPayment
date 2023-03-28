import ABI from '../../blockchain/artifacts/contracts/SUCoin.sol/SUCoin.json';
import { Network } from 'alchemy-sdk';

enum ETH {
    API_KEY = "WT9iIsSG05wOTKJWBoGGC9O6ky24UKf7",
    AUTH_TOKEN = "_RXj2lZRspHAbBU74dHqDv0khzi1xNvA",
    PRIVATE_KEY = "dfb496222786b753eab820acc09d453e06313530e1e03546aa5c49ffcfbd1dcd",
    CONTRACT_ADDRESS = "0x0c46900947843203f0805763dCFAA3A2bC60f145",
}

enum MATIC {
    API_KEY = "9OSnIEkkN3VwywBxQS-9ygZkxy3hIWeW",
    AUTH_TOKEN = "_RXj2lZRspHAbBU74dHqDv0khzi1xNvA",
    PRIVATE_KEY = "84902db032a4f0f02c14f041099c57eb2a29246ebd1e22dd8d1828bdcead122a",
    CONTRACT_ADDRESS = "0x0c46900947843203f0805763dCFAA3A2bC60f145",
}

export class NetworkSettings {
    readonly API_KEY: string;
    readonly AUTH_TOKEN: string;
    readonly PRIVATE_KEY: string;
    readonly CONTRACT_ADDRESS: string;
    static readonly ABI = ABI.abi;

    constructor (chain: Network) {
        this.API_KEY = ETH.API_KEY;
        this.AUTH_TOKEN = ETH.AUTH_TOKEN;
        this.PRIVATE_KEY = ETH.PRIVATE_KEY;
        this.CONTRACT_ADDRESS = ETH.CONTRACT_ADDRESS;

        if (chain == Network.MATIC_MUMBAI) {
            this.API_KEY = MATIC.API_KEY;
            this.AUTH_TOKEN = MATIC.AUTH_TOKEN;
            this.PRIVATE_KEY = MATIC.PRIVATE_KEY;
            this.CONTRACT_ADDRESS = MATIC.CONTRACT_ADDRESS;
        }
    }
}

export class AppSettings {
    static readonly PORT = 3000;
    static readonly webhook_id = "wh_7r2u4rtc7lgwu2y1";
    static readonly server_url = "https://2320-159-20-68-5.eu.ngrok.io";
}