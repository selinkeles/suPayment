import 'package:app/UI/colors.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/transaction_pages/main_page.dart';
import 'package:app/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../misc/entries.dart';
import '../../misc/searchbar.dart';
import '../../misc/wallet.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanning = false;
  TextEditingController _amountController = TextEditingController();
  String _qrData = '';

  @override
  void dispose() {
    _amountController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    /*List<dynamic> entries = Provider.of<Entries>(context).newEntries;*/
    if (walletProvider.wallet != null) {
      Wallett wallet = walletProvider.wallet!;
    }
    var height = MediaQuery.of(context).size.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            TabBar(
              tabs: [
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          AppText(
                            text: "Receive",
                            color: AppColors.bigTextColor,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Transfer",
                            color: AppColors.bigTextColor,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.mainColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              indicatorColor: AppColors.mainColor,
              labelColor: AppColors.bigTextColor,
            ),
            Expanded(
              child: TabBarView(children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter the amount you want to receive',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return AppColors.buttonBackground;
                              },
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (walletProvider.wallet?.wallet_id != null) {
                                _qrData = _amountController.text +
                                  "|" +
                                  walletProvider.wallet!.wallet_id;
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: AppText(
                                  text: "You must connect with metamask first!",
                                  color: Colors.white,
                                ),
                                duration: const Duration(seconds: 1),
                              ));
                              }
                              print(_qrData);
                            });
                          },
                          child: AppText(
                            text: 'Generate QR Code',
                            color: Colors.white,
                          ),
                        ),
                        if (_qrData.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.mainColor, width: 5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: QrImage(
                                    data: _qrData,
                                    version: QrVersions.auto,
                                    size: 310,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*SearchBar(userList: entries.map((item) => item.toString()).toList(),),*/
                          AppText(
                            text: 'Scan the QR code for making a transaction',
                            color: Colors.black54,
                            size: 18,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (walletProvider.wallet?.wallet_id != null) {
                                _startScan();
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: AppText(
                                    text: "You must connect with metamask first!",
                                    color: Colors.white,
                                  ),
                                  duration: const Duration(seconds: 1),));
                              }  
                            },
                            child: Icon(Icons.camera_alt_rounded),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonBackground,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                            ),
                          ),
                          if (_isScanning)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isScanning,
                      child: Scaffold(
                        body: QRView(
                          key: _qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: 300,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ],
        )));
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller!.pauseCamera();

      setState(() {
        _isScanning = false;
      });

      _parseQRData(scanData.code!);
    });
  }

  Future<void> _parseQRData(String qrData) async {
    try {
      List<String> parts = qrData.split('|');
      if (parts.length == 2) {
        String amount = parts[0];
        String wallet = parts[1];
        print('Amount: $amount, Wallet: $wallet');
      } else {
        print('Invalid input string');
      }
      /*showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Amount Information'),
          content: Text('Amount: ${data['amount']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );*/
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid QR code'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
