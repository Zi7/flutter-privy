import 'dart:convert';

class UserProfile {
  final int id;
  final String privyId;
  final String uid;
  final String status;
  final String? deletedAt;
  final String? lastLoginAt;
  final PrivyUser? privyUser;

  UserProfile({
    required this.id,
    required this.privyId,
    required this.uid,
    required this.status,
    this.deletedAt,
    this.lastLoginAt,
    this.privyUser,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] ?? 0,
    privyId: json['privyId'] ?? '',
    uid: json['uid'] ?? '',
    status: json['status'] ?? '',
    deletedAt: json['deletedAt'],
    lastLoginAt: json['lastLoginAt'],
    privyUser:
        json['privyUser'] != null
            ? PrivyUser.fromJson(json['privyUser'])
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'privyId': privyId,
    'uid': uid,
    'status': status,
    'deletedAt': deletedAt,
    'lastLoginAt': lastLoginAt,
    'privyUser': privyUser?.toJson(),
  };
}

class PrivyUser {
  final int userId;
  final String privyId;
  final bool isGuest;
  final List<LinkedAccount> linkedAccounts;
  final List<Wallet> wallets;

  PrivyUser({
    required this.userId,
    required this.privyId,
    required this.isGuest,
    required this.linkedAccounts,
    required this.wallets,
  });

  factory PrivyUser.fromJson(Map<String, dynamic> json) => PrivyUser(
    userId: json['userId'] ?? 0,
    privyId: json['privyId'] ?? '',
    isGuest: json['isGuest'] ?? false,
    linkedAccounts:
        (json['linkedAccounts'] as List?)
            ?.map((e) => LinkedAccount.fromJson(e))
            .toList() ??
        [],
    wallets:
        (json['wallets'] as List?)?.map((e) => Wallet.fromJson(e)).toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'privyId': privyId,
    'isGuest': isGuest,
    'linkedAccounts': linkedAccounts.map((e) => e.toJson()).toList(),
    'wallets': wallets.map((e) => e.toJson()).toList(),
  };
}

class LinkedAccount {
  final String type;
  final String address;
  final bool? verified;
  final String? walletType;

  LinkedAccount({
    required this.type,
    required this.address,
    this.verified,
    this.walletType,
  });

  factory LinkedAccount.fromJson(Map<String, dynamic> json) => LinkedAccount(
    type: json['type'] ?? '',
    address: json['address'] ?? '',
    verified: json['verified'],
    walletType: json['wallet_type'],
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'address': address,
    'verified': verified,
    'wallet_type': walletType,
  };
}

class Wallet {
  final int id;
  final String type;
  final String privyWalletId;
  final String address;
  final String chainId;
  final String chainType;
  final String connectorType;

  Wallet({
    required this.id,
    required this.type,
    required this.privyWalletId,
    required this.address,
    required this.chainId,
    required this.chainType,
    required this.connectorType,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json['id'] ?? 0,
    type: json['type'] ?? '',
    privyWalletId: json['privyWalletId'] ?? '',
    address: json['address'] ?? '',
    chainId: json['chainId'] ?? '',
    chainType: json['chainType'] ?? '',
    connectorType: json['connectorType'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'privyWalletId': privyWalletId,
    'address': address,
    'chainId': chainId,
    'chainType': chainType,
    'connectorType': connectorType,
  };
}

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
  final List<Balance>? balances;

  Data({this.balances});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    balances:
        json["balances"] == null
            ? []
            : List<Balance>.from(
              json["balances"]!.map((x) => Balance.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "balances":
        balances == null
            ? []
            : List<dynamic>.from(balances!.map((x) => x.toJson())),
  };
}

class Balance {
  final String? chain;
  final String? asset;
  final String? rawValue;
  final int? rawValueDecimals;
  final DisplayValues? displayValues;

  Balance({
    this.chain,
    this.asset,
    this.rawValue,
    this.rawValueDecimals,
    this.displayValues,
  });

  factory Balance.fromRawJson(String str) => Balance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
    chain: json["chain"],
    asset: json["asset"],
    rawValue: json["raw_value"],
    rawValueDecimals: json["raw_value_decimals"],
    displayValues:
        json["display_values"] == null
            ? null
            : DisplayValues.fromJson(json["display_values"]),
  );

  Map<String, dynamic> toJson() => {
    "chain": chain,
    "asset": asset,
    "raw_value": rawValue,
    "raw_value_decimals": rawValueDecimals,
    "display_values": displayValues?.toJson(),
  };
}

class DisplayValues {
  final String? sol;
  final String? eth;
  final String? usd;

  DisplayValues({this.sol, this.eth, this.usd});

  factory DisplayValues.fromRawJson(String str) =>
      DisplayValues.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DisplayValues.fromJson(Map<String, dynamic> json) =>
      DisplayValues(sol: json["sol"], eth: json["eth"], usd: json["usd"]);

  Map<String, dynamic> toJson() => {"sol": sol, "eth": eth, "usd": usd};
}

class Asset {
  final String? address;
  final String type;

  Asset({this.address, required this.type});

  factory Asset.fromJson(Map<String, dynamic> json) =>
      Asset(address: json['address'], type: json['type'] ?? '');

  Map<String, dynamic> toJson() => {'address': address, 'type': type};
}
