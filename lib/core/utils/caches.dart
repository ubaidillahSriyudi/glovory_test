import 'package:shared_preferences/shared_preferences.dart';

class LocalCaches {
  static String everLoged = 'loged';

  ///Saving Data Token to shared preferences
  static Future<void> storeLocalCaches(bool val) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(everLoged, val);
  }

  ///Fetch Access Token from shared preferences
  static Future<bool?> getLocal() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(everLoged);
  }
}
