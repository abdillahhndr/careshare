import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? idUser, username, email, address;

  Future<void> saveSession(
      int val, String id, String username, String email, String address) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
    pref.setString("username", username);
    pref.setString("email", email);
    pref.setString("address", address);
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    value = pref.getInt("value");
    idUser = pref.getString("id");
    username = pref.getString("username");
    email = pref.getString("email");
    address = pref.getString("address");
    return value;
  }

  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();
