import 'package:app/pages/home_page.dart';
import 'package:app/UI/colors.dart';
import 'package:app/pages/transaction_pages/buy_page.dart';
import 'package:app/pages/transaction_pages/sell_page.dart';
import 'package:app/pages/transaction_pages/transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  var _walletid;
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isConnected = false;
  List pages = [HomePage(), BuyPage(), const SellPage(), TransferPage()];
  Future<void> _loadConnected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConnected = prefs.getBool('isConnected') ?? false;
    setState(() {
      _isConnected = isConnected;
    });
  }
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadConnected();
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
          BottomNavigationBarItem(
              label: "Home", icon: Icon(Icons.apps_rounded)),
          BottomNavigationBarItem(
              label: "Buy", icon: Icon(Icons.payments_sharp)),
          BottomNavigationBarItem(
              label: "Sell", icon: Icon(Icons.payments_outlined)),
          BottomNavigationBarItem(label: "Transfer", icon: Icon(Icons.qr_code))
        ],
      ),
    );
  }
}
