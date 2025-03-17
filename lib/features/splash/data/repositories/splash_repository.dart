import 'package:shared_preferences/shared_preferences.dart';

/*
  This class is responsible for checking if the user is a first time user or not.
  If the user is a first time user, it will return true, otherwise it will return false.
*/

class SplashRepository
{
  Future<bool> isFirstTimeUser() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTimeUser = prefs.getBool('first_time_user');
    if(firstTimeUser == null || firstTimeUser)
      {
        await prefs.setBool('first_time_user', false);
        return true;
      }
    return false;
  }
}