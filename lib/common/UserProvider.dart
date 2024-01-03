import 'package:flutter/material.dart';
import '../user.dart';

class UserProvider extends ChangeNotifier {
  User? currentUser;

  void setCurrentUser(User user) {
    currentUser = user;
    notifyListeners();
  }
}