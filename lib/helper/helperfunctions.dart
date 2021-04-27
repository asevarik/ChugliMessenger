import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPrefUserLoggedInKey = "ISLOGEDDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";
  static String sharedPrefUserId = "USERIDKEY";
  //sets usercredentials to local db
  Future<bool> setuserCredentials(
      String username, String useremail, String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("$uid shared prefs ka he ");
    await prefs.setString(sharedPrefUserId, uid);
    await prefs.setString(sharedPrefUserNameKey, username);
    print("all values set to local");
    return await prefs.setString(sharedPrefUserEmailKey, useremail);
  }

  Future<bool> setuserName(String newname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserNameKey, newname);
  }

  //gets the user credentials from local db
  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUserNameKey);
  }

  Future<String> getUseremail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUserEmailKey);
  }

  Future<String> getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUserId);
  }

  Future<bool> clearsharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
