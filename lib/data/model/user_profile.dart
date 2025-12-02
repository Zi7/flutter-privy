import 'dart:convert';

class UserProfile {
  final String? code;
  final String? message;
  final Data? data;

  UserProfile({this.code, this.message, this.data});

  factory UserProfile.fromRawJson(String str) =>
      UserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? id;
  final String? privyId;
  final String? uid;
  final String? status;
  final dynamic deletedAt;
  final DateTime? lastLoginAt;
  final PrivyUserModel? privyUser;
  final List<SmartWallet>? smartWallets;

  Data({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.privyId,
    this.uid,
    this.status,
    this.deletedAt,
    this.lastLoginAt,
    this.privyUser,
    this.smartWallets,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    id: json["id"],
    privyId: json["privyId"],
    uid: json["uid"],
    status: json["status"],
    deletedAt: json["deletedAt"],
    lastLoginAt:
        json["lastLoginAt"] == null
            ? null
            : DateTime.parse(json["lastLoginAt"]),
    privyUser:
        json["privyUser"] == null
            ? null
            : PrivyUserModel.fromJson(json["privyUser"]),
    smartWallets:
        json["smartWallets"] == null
            ? []
            : List<SmartWallet>.from(
              json["smartWallets"]!.map((x) => SmartWallet.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "id": id,
    "privyId": privyId,
    "uid": uid,
    "status": status,
    "deletedAt": deletedAt,
    "lastLoginAt": lastLoginAt?.toIso8601String(),
    "privyUser": privyUser?.toJson(),
    "smartWallets":
        smartWallets == null
            ? []
            : List<dynamic>.from(smartWallets!.map((x) => x.toJson())),
  };
}

class PrivyUserModel {
  final String? id;
  final int? createdAt;
  final List<LinkedAccount>? linkedAccounts;
  final List<dynamic>? mfaMethods;
  final bool? hasAcceptedTerms;
  final bool? isGuest;
  final int? userId;

  PrivyUserModel({
    this.id,
    this.createdAt,
    this.linkedAccounts,
    this.mfaMethods,
    this.hasAcceptedTerms,
    this.isGuest,
    this.userId,
  });

  factory PrivyUserModel.fromRawJson(String str) =>
      PrivyUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrivyUserModel.fromJson(Map<String, dynamic> json) => PrivyUserModel(
    id: json["id"],
    createdAt: json["created_at"],
    linkedAccounts:
        json["linked_accounts"] == null
            ? []
            : List<LinkedAccount>.from(
              json["linked_accounts"]!.map((x) => LinkedAccount.fromJson(x)),
            ),
    mfaMethods:
        json["mfa_methods"] == null
            ? []
            : List<dynamic>.from(json["mfa_methods"]!.map((x) => x)),
    hasAcceptedTerms: json["has_accepted_terms"],
    isGuest: json["is_guest"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "linked_accounts":
        linkedAccounts == null
            ? []
            : List<dynamic>.from(linkedAccounts!.map((x) => x.toJson())),
    "mfa_methods":
        mfaMethods == null ? [] : List<dynamic>.from(mfaMethods!.map((x) => x)),
    "has_accepted_terms": hasAcceptedTerms,
    "is_guest": isGuest,
    "userId": userId,
  };
}

class LinkedAccount {
  final String? type;
  final String? address;
  final int? verifiedAt;
  final int? firstVerifiedAt;
  final int? latestVerifiedAt;
  final String? id;
  final int? walletIndex;
  final String? chainId;
  final dynamic publicKey;
  final String? chainType;
  final bool? delegated;
  final String? walletClient;
  final String? walletClientType;
  final String? connectorType;
  final bool? imported;
  final String? recoveryMethod;

  LinkedAccount({
    this.type,
    this.address,
    this.verifiedAt,
    this.firstVerifiedAt,
    this.latestVerifiedAt,
    this.id,
    this.walletIndex,
    this.chainId,
    this.publicKey,
    this.chainType,
    this.delegated,
    this.walletClient,
    this.walletClientType,
    this.connectorType,
    this.imported,
    this.recoveryMethod,
  });

  factory LinkedAccount.fromRawJson(String str) =>
      LinkedAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LinkedAccount.fromJson(Map<String, dynamic> json) => LinkedAccount(
    type: json["type"],
    address: json["address"],
    verifiedAt: json["verified_at"],
    firstVerifiedAt: json["first_verified_at"],
    latestVerifiedAt: json["latest_verified_at"],
    id: json["id"],
    walletIndex: json["wallet_index"],
    chainId: json["chain_id"],
    publicKey: json["public_key"],
    chainType: json["chain_type"],
    delegated: json["delegated"],
    walletClient: json["wallet_client"],
    walletClientType: json["wallet_client_type"],
    connectorType: json["connector_type"],
    imported: json["imported"],
    recoveryMethod: json["recovery_method"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "address": address,
    "verified_at": verifiedAt,
    "first_verified_at": firstVerifiedAt,
    "latest_verified_at": latestVerifiedAt,
    "id": id,
    "wallet_index": walletIndex,
    "chain_id": chainId,
    "public_key": publicKey,
    "chain_type": chainType,
    "delegated": delegated,
    "wallet_client": walletClient,
    "wallet_client_type": walletClientType,
    "connector_type": connectorType,
    "imported": imported,
    "recovery_method": recoveryMethod,
  };
}

class SmartWallet {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? id;
  final int? userId;
  final String? signerWalletId;
  final String? signerWalletAddress;
  final String? provider;
  final String? externalId;
  final String? address;

  SmartWallet({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.userId,
    this.signerWalletId,
    this.signerWalletAddress,
    this.provider,
    this.externalId,
    this.address,
  });

  factory SmartWallet.fromRawJson(String str) =>
      SmartWallet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SmartWallet.fromJson(Map<String, dynamic> json) => SmartWallet(
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    id: json["id"],
    userId: json["userId"],
    signerWalletId: json["signerWalletId"],
    signerWalletAddress: json["signerWalletAddress"],
    provider: json["provider"],
    externalId: json["externalId"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "id": id,
    "userId": userId,
    "signerWalletId": signerWalletId,
    "signerWalletAddress": signerWalletAddress,
    "provider": provider,
    "externalId": externalId,
    "address": address,
  };
}
