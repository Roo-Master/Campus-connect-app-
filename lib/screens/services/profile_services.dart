import 'package:flutter/foundation.dart';
import 'package:campus_connect/models/user_model.dart';

class ProfileService extends ChangeNotifier {
  UserModel ? _userProfile;

  UserModel ? get userProfile => _userProfile;

  void updateUserProfile( UserModel  profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }
}