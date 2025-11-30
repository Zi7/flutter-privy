import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pure data source for storage operations
/// IMPORTANT: For clean architecture compliance, access storage through StorageUseCase
/// instead of using AppStorage.to directly in presentation/domain layers
class AppStorage extends GetxService {
  static final AppStorage _appStorage = AppStorage._internal();

  factory AppStorage() {
    return _appStorage;
  }
  AppStorage._internal();

  Future<SharedPreferences> sharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<FlutterSecureStorage> flutterSecureStorage() async {
    return const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  }

  Future<bool> setString(String key, String value) {
    SharedPreferences pref = Get.find();
    return pref.setString(key, value);
  }

  String? getString(String key) {
    SharedPreferences pref = Get.find();
    return pref.getString(key);
  }

  setStringSecure(String key, String value) async {
    FlutterSecureStorage storage = Get.find();
    await storage.delete(key: key);
    await storage.write(key: key, value: value);
  }

  Future<String?> getStringSecure(String key) async {
    FlutterSecureStorage storage = Get.find();
    return await storage.read(key: key);
  }

  Future<bool> containKeySecure(String key) async {
    FlutterSecureStorage storage = Get.find();
    return await storage.containsKey(key: key);
  }

  Future<bool> setInt(String key, int value) {
    SharedPreferences pref = Get.find();
    return pref.setInt(key, value);
  }

  int? getInt(String key) {
    SharedPreferences pref = Get.find();
    return pref.getInt(key);
  }

  Future<bool> setBool(String key, bool value) {
    SharedPreferences pref = Get.find();
    return pref.setBool(key, value);
  }

  bool? getBool(String key) {
    SharedPreferences pref = Get.find();
    return pref.getBool(key);
  }

  Future<bool> removeBool(String key) {
    SharedPreferences pref = Get.find();
    return pref.remove(key);
  }

  Future<bool> setListString(String key, List<String> value) {
    SharedPreferences pref = Get.find();
    return pref.setStringList(key, value);
  }

  List<String>? getListString(String key) {
    SharedPreferences pref = Get.find();
    return pref.getStringList(key);
  }

  Future<bool> removeString(String key) {
    SharedPreferences pref = Get.find();
    return pref.remove(key);
  }

  Future<bool> clear() {
    SharedPreferences pref = Get.find();
    return pref.clear();
  }

  Future<void> clearLastestCache() async {
    SharedPreferences pref = Get.find();
    final keys = pref.getKeys();
    for (final key in keys) {
      if (key.contains("lastestCache")) {
        await pref.remove(key);
      }
    }
  }

  Future<void> removeStringSecure(String key) async {
    FlutterSecureStorage storage = Get.find();
    await storage.delete(key: key);
  }
}

final class SKeys {
  SKeys._();

  static const token = 'token';
  static const refreshToken = 'refreshToken';
  static const account = 'account';
  static const countOtp = 'countOtp';
  static const timeStart = 'time';
  static const address = 'address';
  static const cardList = 'cardList';
  static const enableBiometric = 'enableBiometric';
  static const forceEnableBiometric = 'forceEnableBiometric@email';
  static const userName = 'userName';
  static const loginCountryCode = 'loginCountryCode';
  static const loginDialCode = 'loginDialCode';
  static const appTheme = 'appTheme';
  static const registerData = 'registerData';
  static const registerCardData = 'registerCardData';
  static const filterAssetSelected = 'filterAssetSelected';
  static const lastestCache = 'lastestCache@user@endpoint';
  static const notShowUpdateAtNews = 'notShowUpdateAtNews@user@version';

  static String appVersionKey(String userId, String version) {
    return notShowUpdateAtNews.trParams({'user': userId, 'version': version});
  }
}
