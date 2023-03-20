import 'package:app/UI/colors.dart';
import 'package:app/pages/transaction_pages/main_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:app/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class suloginPage extends StatefulWidget {
  const suloginPage({Key? key}) : super(key: key);

  @override
  State<suloginPage> createState() => _suloginPageState();
}

class _suloginPageState extends State<suloginPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
      body: Center(
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
                  AppText(text: "Please provide your SU-Login credentials."),
                  customSizedBox(),
                  TextField(
                    decoration: customInputDecoration("SU-username"),
                  ),
                  customSizedBox(),
                  TextField(
                    decoration: customInputDecoration("Password"),
                  ),
                  customSizedBox(),
                  Center(
                      child: TextButton(
                          onPressed: () {},
                          child: AppText(
                            text: "Forgot my password",
                            color: AppColors.buttonBackground,
                          ))),
                  customSizedBox(),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
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
                            text: "Login",
                            color: Colors.white,
                          ))),
                    ),
                  ),
                  customSizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
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
