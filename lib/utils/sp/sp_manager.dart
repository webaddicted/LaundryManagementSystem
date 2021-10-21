import 'package:laundry/data/bean/login_user_bean.dart';
import 'package:laundry/utils/constant/pref_const.dart';
import 'package:laundry/utils/sp/sp_helper.dart';

class SPManager {
  static void setUserInfo<T>(LoginUserBean user) async {
    // SPHelper.setPreference(
    //     PrefConst.PREF_CUSTOMER_ID, user.customerId.toString());
    SPHelper.setPreference(PrefConst.PREF_NAME, user.name);
    SPHelper.setPreference(PrefConst.PREF_EMAIL, user.emailId);
    SPHelper.setPreference(PrefConst.PREF_DOB, user.dob);
    SPHelper.setPreference(PrefConst.PREF_MOBILE, user.mobileNo);
    SPHelper.setPreference(PrefConst.PREF_PASSWORD, user.password);
    SPHelper.setPreference(PrefConst.PREF_PASSWORD, user.image);
  }

  static Future<LoginUserBean> getUserInfo<T>() async {
    // var customerId =
    //     await SPHelper.getPreference(PrefConst.PREF_CUSTOMER_ID, "");
    var name = await SPHelper.getPreference(PrefConst.PREF_NAME, "");
    var email = await SPHelper.getPreference(PrefConst.PREF_EMAIL, "");
    var dob = await SPHelper.getPreference(PrefConst.PREF_DOB, "");
    var mobile = await SPHelper.getPreference(PrefConst.PREF_MOBILE, "");
    var password = await SPHelper.getPreference(PrefConst.PREF_PASSWORD, "");
    var image = await SPHelper.getPreference(PrefConst.PREF_IMAGE, "");
    var userInfo = LoginUserBean(name, email, mobile, dob, password, image);
    return userInfo;
  }
  static void setMobileNo<T>(String setLogin) {
    SPHelper.setPreference(PrefConst.PREF_MOBILE, setLogin);
  }

  static Future<String> getMobileNo<T>() async {
    var spValue =  await SPHelper.getPreference(PrefConst.PREF_MOBILE, '');
    return spValue;
  }
  static Future<String> getCustomerId<T>() async {
    var spValue = await SPHelper.getPreference(PrefConst.PREF_CUSTOMER_ID, "");
    return spValue;
  }

  static void setAccessToken<T>(String token) {
    SPHelper.setPreference(PrefConst.PREF_ACCESS_TOKEN, token);
  }

  static Future<String> getAccessToken<T>() async {
    var spValue = await SPHelper.getPreference(PrefConst.PREF_ACCESS_TOKEN, "");
    return spValue;
  }

  static Future<Set<String>> getAllKeys() async {
    var spValue = await SPHelper.getAllKeys();
    return spValue;
  }

  static Future<bool> removeKeys(String key) async {
    var spValue = await SPHelper.removeKey(key);
    return spValue;
  }

  static Future<bool> clearPref() async {
    var spValue = await SPHelper.clearPreference();
    return spValue;
  }
}
