import 'dart:async';

import 'package:get/get_connect/http/src/request/request.dart';
import 'package:privyio/data/repositories/app_storage.dart';

FutureOr<Request> requestInterceptor(request) async {
  final token = AppStorage().getString(SKeys.token);
  if (token != null) {
    request.headers['Authorization'] = 'Bearer $token';
  }
  return request;
}

headersAuthorization() {
  return 'Bearer 123';
}
