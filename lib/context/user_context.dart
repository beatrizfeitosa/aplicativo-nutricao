import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int? _userId;

  int? get userId => _userId;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners(); // Notifica os widgets que usam esse provider sobre a mudança
  }

  void clearUserId() {
    _userId = null;
    notifyListeners();
  }
}
