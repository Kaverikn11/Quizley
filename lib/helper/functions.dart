import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // ignore: non_constant_identifier_names
  static String UserLoggedInKey = "USERLOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAIL";
  static String userTypeKey = "USERTYPE";

  saveUserLoggedInDetails({@required bool isLoggedin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserLoggedInKey, isLoggedin);
  }

  getUserLoggedInDetails({bool isLoggedin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(UserLoggedInKey);
  }

  static saveUserTypeDetails({@required String userType}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(HelperFunctions.userTypeKey, userType);
  }

  static Future<String> getUserTypeDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(HelperFunctions.userTypeKey);
  }
}
