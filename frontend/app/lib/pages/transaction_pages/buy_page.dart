import 'dart:convert';
import 'package:app/UI/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:clipboard/clipboard.dart';


import '../../widgets/app_large_text.dart';
import '../../widgets/app_text.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  static const IconData copy = IconData(0xe190, fontFamily: 'MaterialIcons');
  final _IBAN = "TR50 0004 6008 6688 8000 1415 98";
  final _Receiver = "AKBANK SABANCI UNIVERSITY";
  final _Description = "SUcoin Transfer";

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: AppLargeText(
          text: "Buy SUcoin",
          size: 25,
          color: Colors.white70,
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            height: height * .20,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/sabanci.png"))),
          ),
          const SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            AppText(text: "İşlem süresi",color: Colors.black, size: 20,),
            AppText(text: "Bir saat",color: Colors.indigoAccent,size:20,),
          ],
          ),
          const SizedBox(
            height: 15,
          ),
           Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            AppText(text: "Hesap Tipi",color: Colors.black, size: 20,),
            AppText(text: "Türk Lirası",color: Colors.indigoAccent,size:20,),
          ],
          ),
          const SizedBox(
            height: 15,
          ),
           Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            AppText(text: "IBAN",color: Colors.black, size: 20,),
            Container(
              child: Row(
                children: [
                  AppText(text: _IBAN,color: Colors.indigoAccent,size:16,),
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        icon: const Icon(copy),
                        splashRadius: 20.0,
                        iconSize: 15,
                        color: Colors.indigoAccent,
                        onPressed: () {
                          FlutterClipboard.copy(_IBAN);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Copied to clipboard'),
                          ));
                        },
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
          ),
          const SizedBox(
            height: 15,
          ),
           Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            AppText(text: "Alıcı",color: Colors.black, size: 20,),
            Container(
              child: Row(
                children: [
                  AppText(text: _Receiver,color: Colors.indigoAccent,size:16,),
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        icon: const Icon(copy),
                        splashRadius: 20.0,
                        iconSize: 15,
                        color: Colors.indigoAccent,
                        onPressed: () {
                          FlutterClipboard.copy(_Receiver);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Copied to clipboard'),
                          ));
                        },
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
          ),
          const SizedBox(
            height: 15,
          ),
           Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            AppText(text: "Açıklama*",color: Colors.black, size: 20,),
            Container(
              child: Row(
                children: [
                  AppText(text: _Description,color: Colors.indigoAccent,size:16,),
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        icon: const Icon(copy),
                        splashRadius: 20.0,
                        iconSize: 15,
                        color: Colors.indigoAccent,
                        onPressed: () {
                          FlutterClipboard.copy(_Description);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Copied to clipboard'),
                          ));
                        },
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
          ),
          const SizedBox(
            height: 15,
          ),
           Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),

         
          AppLargeText(text: "How to buy SUcoin"),
          const SizedBox(
            height: 20,
          ),
          AppText(
              text:
                  "1) Copy University IBAN above \n\n2) Send 1 TL for 1 SUcoin")
        ]),
      ),
    );
  }
}
