import 'package:flutter/material.dart';
import 'package:travel_app/models/UserDto.dart';

class UserDataProvider extends ChangeNotifier {
  UserDto? _loggedInUser;

  UserDto? get loggedInUser => _loggedInUser;

  void setLoggedInUser(UserDto? user) {
    _loggedInUser = user;
    notifyListeners();
  }

  void clearLoggedInUser() {
    _loggedInUser = null;
    notifyListeners();
  }
}
