import 'dart:convert';

class WalletBalance {
  final String? code;
  final String? message;
  final Data? data;

  WalletBalance({this.code, this.message, this.data});

  factory WalletBalance.fromRawJson(String str) =>
      WalletBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
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
  final String? address;
  final String? network;
  final Native? native;
  final List<dynamic>? tokens;
  final int? totalTokens;

  Data({
    this.address,
    this.network,
    this.native,
    this.tokens,
    this.totalTokens,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    address: json["address"],
    network: json["network"],
    native: json["native"] == null ? null : Native.fromJson(json["native"]),
    tokens:
        json["tokens"] == null
            ? []
            : List<dynamic>.from(json["tokens"]!.map((x) => x)),
    totalTokens: json["totalTokens"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "network": network,
    "native": native?.toJson(),
    "tokens": tokens == null ? [] : List<dynamic>.from(tokens!.map((x) => x)),
    "totalTokens": totalTokens,
  };
}

class Native {
  final String? address;
  final String? balance;
  final String? balanceFormatted;
  final String? network;

  Native({this.address, this.balance, this.balanceFormatted, this.network});

  factory Native.fromRawJson(String str) => Native.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Native.fromJson(Map<String, dynamic> json) => Native(
    address: json["address"],
    balance: json["balance"],
    balanceFormatted: json["balanceFormatted"],
    network: json["network"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "balance": balance,
    "balanceFormatted": balanceFormatted,
    "network": network,
  };
}
