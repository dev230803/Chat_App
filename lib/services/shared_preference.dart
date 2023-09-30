import 'package:shared_preferences/shared_preferences.dart';

class SharedPReferenceData{

  static String userIdKey="USERKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userPicKey="USERPICKEY";
  static String userDisplayNameKey="USERDISPNAMEKEY";

  Future<bool>saveUserId(String getUSerId)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userIdKey, getUSerId);
  }

  Future<bool>saveUserEmail(String getUSerEmail)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userEmailKey, getUSerEmail);
  }
  
  Future<bool>saveUserPic(String getUSerPic)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userPicKey, getUSerPic);
  }

  Future<bool>saveUserName(String getUSerName)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userNameKey, getUSerName);
  }

  Future<bool>saveUserDisplayName(String getUSerDisplayName)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userDisplayNameKey, getUSerDisplayName);
  }

  Future<String?>getuserId()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userIdKey);
  }
  Future<String?>getUSerEmail()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }
  Future<String?>getUSerPic()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userPicKey);
  }
  Future<String?>getUSerName()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userNameKey);
  }
  Future<String?>getUSerDisplayName()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDisplayNameKey);
  }


}