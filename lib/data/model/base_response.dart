import 'dart:convert';

class BaseResponse {
  final bool success;
  final String message;
  final dynamic data;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        success: json['message'] == 'success',
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
      };

  toRawJson() => jsonEncode(toJson());
}
