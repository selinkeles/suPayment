import 'package:app/pages/home_page.dart';
import 'package:app/misc/colors.dart';
import 'package:app/pages/transaction_pages/buy_page.dart';
import 'package:app/pages/transaction_pages/sell_page.dart';
import 'package:app/pages/transaction_pages/transfer_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const BuyPage(),
    const SellPage(),
    const TransferPage()
  ];
  int currentIndex=0;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainTextColor,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.mainColor,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(label: "Home",
              icon: Icon(Icons.apps_rounded)),
          BottomNavigationBarItem(label: "Buy",
              icon: Icon(Icons.payments_sharp)),
          BottomNavigationBarItem(label: "Sell",
              icon: Icon(Icons.payments_outlined)),
          BottomNavigationBarItem(label: "Transfer",
              icon: Icon(Icons.qr_code))
        ],
      ),
    );
  }
}
