import 'dart:convert';

import 'package:app/UI/colors.dart';
import 'package:app/pages/transaction_pages/main_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:app/widgets/app_text.dart';
import 'package:http/http.dart' as http;
import 'package:app/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../misc/wallet.dart';
import 'package:provider/provider.dart';

class suloginPage extends StatefulWidget {
  const suloginPage({Key? key}) : super(key: key);

  @override
  State<suloginPage> createState() => _suloginPageState();
}

class _suloginPageState extends State<suloginPage> {
  TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _textFieldValue = '';
  
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final walletProvider = Provider.of<WalletProvider>(context);

    if (walletProvider.wallet != null) {
      Wallett wallet = walletProvider.wallet!;
      print(walletProvider.wallet!.wallet_id);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            color: AppColors.buttonBackground,
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customSizedBox(),
              Container(
                height: height * .23,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/sabanci.png"))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customSizedBox(),
                    AppLargeText(text: "Welcome"),
                    AppText(text: "Please provide your credentials."),
                    customSizedBox(),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    customSizedBox(),
                    AppText(
                    text: walletProvider.wallet!.wallet_id,
                      color: Color.fromARGB(255, 65, 100, 147),
                    ),
                    customSizedBox(),
                    /*Center(
                        child: TextButton(
                            onPressed: () {},
                            child: AppText(
                              text: "Forgot my password",
                              color: AppColors.buttonBackground,
                            ))),
                    customSizedBox(),*/
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          try {
                            var response = await linkWallet(_emailController.text, walletProvider.wallet!.wallet_id);
                            if (response.statusCode == 200) {
                              print(response.body);
                            } else {
                              print("gitmedi");
                            }
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.buttonBackground),
                            child: Center(
                                child: AppText(
                                  text: "Link",
                                  color: Colors.white,
                            ))),
                      ),
                    ),
                    customSizedBox(),
                    /*Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()),
                              );
                            },
                            child: AppText(
                              text: "Do not have an account?",
                              color: AppColors.buttonBackground,
                            ))),*/
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> linkWallet(String email, String walletId) {
  var url = Uri.parse('https://2320-159-20-68-5.eu.ngrok.io/link');
  return http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'wallet': walletId,
    }),
  );
}

  Widget customSizedBox() => const SizedBox(
        height: 20,
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor)));
  }
}