import 'dart:convert';

class CreateTxRequest {
  final int smartWalletId;
  final double amount;
  final String? token;
  final String chain;
  final String recipientAddress;

  CreateTxRequest({
    required this.smartWalletId,
    required this.amount,
    this.token,
    required this.chain,
    required this.recipientAddress,
  });

  factory CreateTxRequest.fromRawJson(String str) =>
      CreateTxRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateTxRequest.fromJson(Map<String, dynamic> json) =>
      CreateTxRequest(
        smartWalletId: json["smartWalletId"],
        amount: json["amount"].toDouble(),
        token: json["token"],
        chain: json["chain"],
        recipientAddress: json["recipientAddress"],
      );

  Map<String, dynamic> toJson() => {
    "smartWalletId": smartWalletId,
    "amount": amount,
    if (token != null) "token": token,
    "chain": chain,
    "recipientAddress": recipientAddress,
  };
}
