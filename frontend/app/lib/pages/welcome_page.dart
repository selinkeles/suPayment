import 'package:app/UI/colors.dart';
import 'package:app/pages/transaction_pages/main_page.dart';
import 'package:app/widgets/app_large_text.dart';
import 'package:app/widgets/app_text.dart';
import 'package:app/widgets/responsive_button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    "welcome_page_1.png",
    "welcome_page_4.png",
    "welcome_page_3.png"
  ];

  List largeTexts = ["SU Wallet", "Pay by", "Use"];

  List subTexts = ["Web3 of Sabanci University", "SUcoin", "at campus"];

  List descriptions = [
    "1. Connect to your favorite crypto wallet\n2. Link your SU account if desired\n3. ..that's it really, Enjoy!",
    "Make transactions by the unique cryptocurrency of Sabanci University via your Metamask account and SUpayment app.",
    "Use the app in every enterprise in campus. Cafeteria, Piazza, Fasshane, PizzaBulls etc. Basically EVERYWHERE!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/" + images[index]),
                      fit: BoxFit.cover)),
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(text: largeTexts[index]),
                        AppText(text: subTexts[index], size: 28),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250,
                          child: AppText(
                            text: descriptions[index],
                            color: AppColors.textColor2,
                            size: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  return AppColors.mainColor;
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()),
                              );
                            },
                            child: ResponsiveButton(
                              width: 120,
                            )),
                      ],
                    ),
                    Column(
                      children: List.generate(3, (indexDots) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          width: 8,
                          height: index == indexDots ? 25 : 8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index == indexDots
                                  ? AppColors.mainColor
                                  : AppColors.mainColor.withOpacity(0.4)),
                        );
                      }),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
