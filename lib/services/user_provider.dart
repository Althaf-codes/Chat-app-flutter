import 'package:chatappp_socketio/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
