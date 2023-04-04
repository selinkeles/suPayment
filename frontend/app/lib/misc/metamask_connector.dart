import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MetamaskConnector {
  late String metamaskUri;
  late SessionStatus metamaskSession;
  late String metamaskAccount;
  late String metamaskSignature;

  final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'SU Wallet',
          description: 'An app for a new payment.',
          url: 'https://walletconnect.org',
          icons: []));

  WalletConnect getConnector() {
    return connector;
  }

  String getAccount() {
    return metamaskAccount;
  }

  bool isConnected() {
    return connector.connected;
  }

  Future<String> loginUsingMetamask() async {
    if (connector.connected == false) {
      try {
        final session =
            await connector.createSession(onDisplayUri: (uri) async {
          metamaskUri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        metamaskSession = session;
        metamaskAccount = session.accounts[0];
        return "Connected";
      } catch (e) {
        return "Error Occured!";
      }
    }
    return "Already Connected";
  }

  Future<String> callContractTransfer(Map transactionParameters) async {
    if (connector.connected) {
      try {
        const method = "eth_sendTransaction";
        List<dynamic> params = [
          {
            "from": transactionParameters["from"],
            "to": transactionParameters["to"],
            "data": transactionParameters["data"],
          }
        ];
        final requestResponse =
            await connector.sendCustomRequest(method: method, params: params);
      } catch (e) {
        return "Error while calling contract";
      }
    }
    return "Not Connected to Wallet";
  }

  Future<String> signMessageWithMetamask(String message) async {
    if (connector.connected) {
      try {
        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(metamaskUri, mode: LaunchMode.externalApplication);

        final signature = await provider.personalSign(
            message: message,
            address: metamaskSession.accounts[0],
            password: "");

        metamaskSignature = signature;
      } catch (e) {
        return "Error while signing transaction";
      }
    }
    return "Not Connected to Wallet";
  }
}
