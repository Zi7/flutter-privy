import 'dart:convert';

class CreateTxResponse {
  final String? code;
  final String? message;
  final Data? data;

  CreateTxResponse({this.code, this.message, this.data});

  factory CreateTxResponse.fromRawJson(String str) =>
      CreateTxResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateTxResponse.fromJson(Map<String, dynamic> json) =>
      CreateTxResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? dataHash;
  final String? walletIdToSign;
  final String? sessionToSubmit;

  Data({this.dataHash, this.walletIdToSign, this.sessionToSubmit});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dataHash: json["dataHash"],
    walletIdToSign: json["walletIdToSign"],
    sessionToSubmit: json["sessionToSubmit"],
  );

  Map<String, dynamic> toJson() => {
    "dataHash": dataHash,
    "walletIdToSign": walletIdToSign,
    "sessionToSubmit": sessionToSubmit,
  };
}
