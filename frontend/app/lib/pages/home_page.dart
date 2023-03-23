import 'dart:io';
import 'package:app/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:app/UI/colors.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
//import '../misc/webSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../misc/wallet.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'SU Wallet',
          description: 'An app for a new payment.',
          url: 'https://walletconnect.org',
          icons: []));

  var _uri, _session, account, _signature, chainId;

  var accountBalance = 0.0;
  var _wallet_id;

  signMessageWithMetamask(BuildContext context, String message) async {
    if (connector.connected) {
      try {
        print("Message received");
        print(message);

        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(_uri, mode: LaunchMode.externalApplication);

        var signature = await provider.personalSign(
            message: message, address: _session.accounts[0], password: "");
        print(signature);

        setState(() {
          _signature = signature;
        });
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    }
  }

  /*
  Future<String> signMsgWithMetamask(String message) async {
    final client = WCClient();
    final response = await client.request({
      "method": "personal_sign",
      "params": [message, from],
      "id": DateTime.now().millisecondsSinceEpoch,
    });
    
    if (response.containsKey("error")) {
      throw Exception(response["error"]["message"]);
    }
    final signature = response["result"] as String;
    return signature;
  }
  */

  var client = WCClient();

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }

  void listenTx(String address) async {
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse("http://10.0.2.2:3000/subscribe"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'addr': address}),
      );
      var decResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decResponse['uri'] as String);
      print(await client.get(uri));
    } finally {
      client.close();
    }
  }

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        listenTx(session.accounts[0]);
        setState(() {
          _session = session;
          account = session.accounts[0];
          _setWallet(context, session.accounts[0]);
        });
      } catch (exp) {
        // print(exp);
      }
    }
  }

  void _setWallet(BuildContext context, String id) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    Wallett wallet = Wallett(
      wallet_id: id,
    );

    walletProvider.setWallet(wallet);
  }

  List entries = ["Transaction A", "Transaction B"];

  void getKnownUsers() async {
    var url = "https://b959-159-20-68-5.eu.ngrok.io";
    var endpoint = "/knownusers";
    var uri = Uri.parse(url + endpoint);

    var res = await http.get(uri);
    print("resalute" + res.body);

    var new_entries = entries;
    final List<dynamic> dataList = jsonDecode(res.body);
    for (var element in dataList) {
      new_entries.add(element['email']);
    }
    setState(() {
      entries = new_entries;
    });
  }

  void contractCall() async {
    var transactionParameters = {
      "from": _session.accounts[0],
      "to": "0xc4eda05ddcdde224f22bf076846440949486a8c6",
      "data": "0x0",
    };

    List<dynamic> params = [
      {
        "from": transactionParameters["from"],
        "to": transactionParameters["to"],
        "data": transactionParameters["data"],
      }
    ];

    String method = "eth_sendTransaction";

    print(params);

    await launchUrl(Uri.parse(connector!.session.toUri()),
        mode: LaunchMode.externalApplication);
    final signature =
        await connector.sendCustomRequest(method: method, params: params);

    print(signature);
  }

  @override
  void initState() {
    // TODO: implement initState
    // SocketService().connected();
    const ws_url = "https://b597-159-20-68-5.eu.ngrok.io";
    IO.Socket socket =
        IO.io(ws_url, IO.OptionBuilder().setTransports(["websocket"]).build());

    socket.onConnect((_) {
      print("connect");
      socket.emit("client-event", "test");
      socket.on("server-event", (data) => print("server-event: $data"));
      socket.on("notification", (data) => print("notif received: $data"));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppLargeText(
            text: "SU Wallet", color: AppColors.mainColor, size: 27),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.starColor,
            backgroundImage: AssetImage("assets/images/avatar.jpeg"),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => {loginUsingMetamask(context)},
            icon: const Icon(Icons.wallet),
            iconSize: 100,
          ),
          /* IconButton(
            onPressed: () => {getNetworkName(_session.chainId)},
            icon: const Icon(Icons.wallet),
            iconSize: 100,
          ),*/
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: getKnownUsers, child: const Text('get users')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: contractCall, child: const Text('contrat call')),
              const Divider(
                color: AppColors.textColor2,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: AppColors.mainColor, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                            text: "Account Balance",
                            color: AppColors.bigTextColor,
                            size: 15),
                        AppLargeText(
                          text: "25 ETH",
                          color: AppColors.bigTextColor,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                color: AppColors.textColor2,
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(
                    text: "Recent Transactions",
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.mainColor, width: 3),
                      borderRadius: BorderRadius.circular(12)),
                  height: height * .53,
                  child: ListView.separated(
                    itemCount: entries.length,
                    padding: const EdgeInsets.all(2),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: AppColors.buttonBackground,
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        child: Center(
                            child: AppText(
                          text: "${entries[index]}",
                          color: Colors.white,
                        )),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
