import 'package:app/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert';
import 'package:app/UI/colors.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../misc/wallet.dart';

import '../misc/metamask_connector.dart';
import '../misc/server_connector.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MetamaskConnector metamaskConnector;
  late WalletConnect connector;
  late String userAddress;
  late ServerConnector serverConnector;
  late io.Socket socket;
  late List<String> transactions;
  late double accountBalance;
  late Map transactionParameters;

  void initializeMetamaskConnector() {
    metamaskConnector = MetamaskConnector();
    connector = metamaskConnector.getConnector();
    userAddress = metamaskConnector.getAccount();
  }

  void initializeServerConnector() {
    serverConnector = ServerConnector(userAddress);
    socket = serverConnector.getSocket();
  }

  void doNothing() {
    ;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final walletProvider = Provider.of<WalletProvider>(context);
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
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        isConnected: metamaskConnector.isConnected(),
                      )),
            );
          },
          icon: const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.starColor,
            backgroundImage: AssetImage("assets/images/avatar.jpeg"),
          ),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: (walletProvider.wallet?.wallet_id != null)
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.starColor, width: 1)),
                child: IconButton(
                  onPressed: () => {
                    (walletProvider.wallet?.wallet_id != null)
                        ? doNothing()
                        : metamaskConnector.loginUsingMetamask()
                  },
                  icon: CircleAvatar(
                    radius: 20,
                    backgroundColor: (walletProvider.wallet?.wallet_id != null)
                        ? Colors.green
                        : Colors.white,
                    backgroundImage:
                        const AssetImage("assets/images/metamask_logo.png"),
                  ),
                ),
              ),
            ],
          ),
          /* IconButton(
            onPressed: () => {getNetworkName(_session.chainId)},
            icon: const Icon(Icons.wallet),
            iconSize: 100,
          ),*/
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      serverConnector.getUsers();
                    },
                    child: const Text('get users')),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      metamaskConnector
                          .callContractTransfer(transactionParameters);
                    },
                    child: const Text('contrat call')),
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
                        border:
                            Border.all(color: AppColors.mainColor, width: 3),
                        borderRadius: BorderRadius.circular(12)),
                    height: transactions.length * 65,
                    child: ListView.separated(
                      itemCount: transactions.length,
                      padding: const EdgeInsets.all(2),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: AppColors.buttonBackground,
                              borderRadius: BorderRadius.circular(10)),
                          height: 50,
                          child: Center(
                              child: AppText(
                            text: transactions[index],
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
      ),
    );
  }
}
