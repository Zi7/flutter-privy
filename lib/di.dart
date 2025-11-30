import 'package:get/get.dart';
import 'package:privyio/data/repositories/app_storage.dart';

import 'data/repositories/api_repo.dart';

class DI {
  static Future<void> init() async {
    Get.put(AppStorage());
    Get.put(ApiRepo());
    await Get.putAsync(
      () async => await AppStorage().sharedPreferences(),
      permanent: true,
    );
  }
}
