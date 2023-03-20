import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../UI/colors.dart';
import '../../widgets/app_large_text.dart';
import '../../widgets/app_text.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  TextEditingController _ibanController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: AppLargeText(
          text: "Sell SUcoin",
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
          TextField(
            controller: _ibanController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Please enter the amount',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLargeText(
                    text: "Available coin",
                    color: AppColors.bigTextColor,
                    size: 15),
                AppLargeText(
                  text: "25 SUc",
                  color: AppColors.bigTextColor,
                  size: 15,
                )
              ],
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
              content: AppText(
                text: "Your transaction has successfully sent!",
                color: Colors.white,
              ),
              duration: const Duration(seconds: 1),
            ));
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
