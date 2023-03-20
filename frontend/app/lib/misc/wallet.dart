import 'package:flutter/material.dart';

class Wallett {
  final String wallet_id;

  Wallett({
   required this.wallet_id
});

}

class WalletProvider with ChangeNotifier {
  Wallett? _wallet;

  Wallett? get wallet => _wallet;

  void setWallet(Wallett newWallet) {
    _wallet = newWallet;
    notifyListeners();
    }
}