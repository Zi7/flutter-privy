import 'dart:convert';

class PrivyTransactionsResponse {
  final String? code;
  final String? message;
  final Data? data;

  PrivyTransactionsResponse({this.code, this.message, this.data});

  factory PrivyTransactionsResponse.fromRawJson(String str) =>
      PrivyTransactionsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrivyTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      PrivyTransactionsResponse(
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
  final List<Transaction>? transactions;
  final dynamic nextCursor;

  Data({this.transactions, this.nextCursor});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactions:
        json["transactions"] == null
            ? []
            : List<Transaction>.from(
              json["transactions"]!.map((x) => Transaction.fromJson(x)),
            ),
    nextCursor: json["next_cursor"],
  );

  Map<String, dynamic> toJson() => {
    "transactions":
        transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "next_cursor": nextCursor,
  };
}

class Transaction {
  final String? caip2;
  final String? transactionHash;
  final String? status;
  final int? createdAt;
  final String? privyTransactionId;
  final String? walletId;
  final Details? details;

  Transaction({
    this.caip2,
    this.transactionHash,
    this.status,
    this.createdAt,
    this.privyTransactionId,
    this.walletId,
    this.details,
  });

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    caip2: json["caip2"],
    transactionHash: json["transaction_hash"],
    status: json["status"],
    createdAt: json["created_at"],
    privyTransactionId: json["privy_transaction_id"],
    walletId: json["wallet_id"],
    details: json["details"] == null ? null : Details.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "caip2": caip2,
    "transaction_hash": transactionHash,
    "status": status,
    "created_at": createdAt,
    "privy_transaction_id": privyTransactionId,
    "wallet_id": walletId,
    "details": details?.toJson(),
  };
}

class Details {
  final String? type;
  final String? chain;
  final String? asset;
  final String? sender;
  final dynamic senderPrivyUserId;
  final String? recipient;
  final dynamic recipientPrivyUserId;
  final String? rawValue;
  final int? rawValueDecimals;
  final DisplayValues? displayValues;

  Details({
    this.type,
    this.chain,
    this.asset,
    this.sender,
    this.senderPrivyUserId,
    this.recipient,
    this.recipientPrivyUserId,
    this.rawValue,
    this.rawValueDecimals,
    this.displayValues,
  });

  factory Details.fromRawJson(String str) => Details.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    type: json["type"],
    chain: json["chain"],
    asset: json["asset"],
    sender: json["sender"],
    senderPrivyUserId: json["sender_privy_user_id"],
    recipient: json["recipient"],
    recipientPrivyUserId: json["recipient_privy_user_id"],
    rawValue: json["raw_value"],
    rawValueDecimals: json["raw_value_decimals"],
    displayValues:
        json["display_values"] == null
            ? null
            : DisplayValues.fromJson(json["display_values"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "chain": chain,
    "asset": asset,
    "sender": sender,
    "sender_privy_user_id": senderPrivyUserId,
    "recipient": recipient,
    "recipient_privy_user_id": recipientPrivyUserId,
    "raw_value": rawValue,
    "raw_value_decimals": rawValueDecimals,
    "display_values": displayValues?.toJson(),
  };
}

class DisplayValues {
  final String? eth;

  DisplayValues({this.eth});

  factory DisplayValues.fromRawJson(String str) =>
      DisplayValues.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DisplayValues.fromJson(Map<String, dynamic> json) =>
      DisplayValues(eth: json["eth"]);

  Map<String, dynamic> toJson() => {"eth": eth};
}
