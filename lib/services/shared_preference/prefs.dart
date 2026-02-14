import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<bool> saveUserId(String user_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString('user_id', user_id);
  }

  static Future<String> loadUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('user_id') ?? '';
    return token;
  }

  static Future<bool> deleteUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('user_id');
  }
}
