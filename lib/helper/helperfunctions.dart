import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSharedPreference(bool userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, userName);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userName);
  }

  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }
}
