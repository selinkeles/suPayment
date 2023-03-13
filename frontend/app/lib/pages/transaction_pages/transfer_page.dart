import 'package:app/misc/colors.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor:AppColors.mainColor),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                width: 280,
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(text: "Amount:", size: 20),
                       TextField(
                         decoration: customInputDecoration("Please enter your amount"),
                       ),

                    ]
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.mainColor
            )
        ),
    );
        }
}