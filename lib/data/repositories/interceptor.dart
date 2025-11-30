import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:privyio/data/repositories/app_storage.dart';
import 'package:privyio/utils/log.dart';

FutureOr<Request> authInterceptor(request) async {
  return request;
}

FutureOr<Request> requestInterceptor(Request request) async {
  String? token = AppStorage().getString(SKeys.token);
  if (token != null && token.isNotEmpty) {
    request.headers['Authorization'] = 'Bearer $token';
  }
  return request;
}

FutureOr<dynamic> responseInterceptor(
  Request request,
  Response response,
) async {
  Log.i('url: ${request.url.toString()}');
  Log.i('response body: ${response.body.toString()}');
  // if (response.statusCode == 401 && !request.url.toString().contains('login')) {
  //   handleErrorStatus(response);
  //   return;
  // }

  return response;
}

void handleErrorStatus(Response response) {
  switch (response.statusCode) {
    case 401:
      break;
    default:
  }

  return;
}
