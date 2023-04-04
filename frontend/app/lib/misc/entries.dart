import 'package:flutter/cupertino.dart';

class Entries extends ChangeNotifier {
  List<dynamic> _newEntries = [];

  List<dynamic> get newEntries => _newEntries;

  void setNewEntries(List<dynamic> entries) {
    _newEntries = entries;
    notifyListeners();
  }
}
