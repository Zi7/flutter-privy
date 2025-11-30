import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:privyio/utils/log.dart';

FutureOr<dynamic> responseInterceptor(
  Request request,
  Response response,
) async {
  Log.i(request.url.toString());
  Log.i(jsonEncode(response.body));
  return response;
}

void handleErrorStatus(Response response) {
  switch (response.statusCode) {
    case 400:
      // final message = ErrorResponse.fromJson(response.body);
      // CommonWidget.toast(message.error);
      break;
    default:
  }

  return;
}
