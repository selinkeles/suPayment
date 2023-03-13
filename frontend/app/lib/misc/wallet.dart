import 'package:flutter/material.dart';

class Wallet {
  final String wallet_id;

  Wallet({
   required this.wallet_id
});

}

class WalletProvider with ChangeNotifier {
  Wallet? _wallet;

  Wallet? get wallet => _wallet;

  void setWallet(Wallet newWallet) {
    _wallet = newWallet;
    notifyListeners();
    }
}