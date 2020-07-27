import 'package:flutter/cupertino.dart';
import 'package:h_pad/models/login/login.dart';
import 'package:h_pad/models/user/UserExtral.dart';

class UserProvider with ChangeNotifier {
  //当前用户Id
  Login _currentUser;
  Login get currentUser => _currentUser;
  set currentUser(Login value) {
    if (_currentUser != value) {
      _currentUser = value;
      notifyListeners();
    }
  }

  UserExtral _currentUserExtral;
  UserExtral get currentUserExtral => _currentUserExtral;
  set currentUserExtral(UserExtral value) {
    if (_currentUserExtral != value) {
      _currentUserExtral = value;
      notifyListeners();
    }
  }
}
