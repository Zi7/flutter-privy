import 'package:get/get.dart';
import 'package:privyio/data/repositories/endpoints.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/request_interceptor.dart';
import 'interceptors/response_interceptor.dart';

class BaseRepository extends GetConnect {
  BaseRepository() {
    _init();
  }

  void _init() {
    httpClient.baseUrl = Endpoints.baseUrl;
    httpClient.addAuthenticator(authInterceptor);
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }
}
