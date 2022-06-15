import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  AuthMethods _authMethods = AuthMethods();

  User? _user ;
  User get getuser=> _user! ;

  Future<void> refreshUser() async{
    User  user = await  _authMethods.getUserDetail();
    _user = user ;

    notifyListeners();
  }

}