import 'dart:convert';
import 'package:app/UI/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
          TextField(
            controller: _ibanController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Please enter IBAN no',
              border: OutlineInputBorder(),
            ),
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
          TextField(
            controller: _descController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Please enter description',
              border: OutlineInputBorder(),
            ),
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
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Please enter amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            height: 1,
            thickness: 1.5,
            color: AppColors.mainColor,
          ),
          const SizedBox(
            height: 20,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 40,
        width: 200,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 3,
          backgroundColor: AppColors.buttonBackground,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                content: AppText(
                  text: "Your transaction has successfully sent!",
                  color: Colors.white,
                )));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppText(
              text: "Send Buy Order",
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
