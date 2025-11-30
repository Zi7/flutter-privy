import 'dart:developer';

import 'package:flutter/foundation.dart';

class Log {
  static void d(String message) {
    if (kDebugMode) {
      log('\x1B[34m${DateTime.now().toIso8601String()}: $message\x1B[0m');
    }
  }

  static void i(String message) {
    if (kDebugMode) {
      log('\x1B[32m${DateTime.now().toIso8601String()}: $message\x1B[0m');
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      log('\x1B[33m${DateTime.now().toIso8601String()}: $message\x1B[0m');
    }
  }

  static void e(String message) {
    if (kDebugMode) {
      log('\x1B[31m${DateTime.now().toIso8601String()}: $message\x1B[0m');
    }
  }
}
