import 'dart:convert';

class LoginRequest {
  final String token;

  LoginRequest({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class AuthResponse {
  final String code;
  final String message;
  final Data data;

  AuthResponse({required this.code, required this.message, required this.data});

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final String accessToken;
  final String refreshToken;
  final User user;

  Data({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String privyId;
  final String status;

  User({required this.id, required this.privyId, required this.status});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], privyId: json["privyId"], status: json["status"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "privyId": privyId,
    "status": status,
  };
}
