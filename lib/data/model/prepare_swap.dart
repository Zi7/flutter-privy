import 'dart:convert';

class PrepareSwap {
  final String fromToken;
  final String toToken;
  final double amount;

  PrepareSwap({required this.fromToken, required this.toToken, required this.amount});

  factory PrepareSwap.fromRawJson(String str) => PrepareSwap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrepareSwap.fromJson(Map<String, dynamic> json) =>
      PrepareSwap(fromToken: json["fromToken"], toToken: json["toToken"], amount: json["amount"]);

  Map<String, dynamic> toJson() => {
    "fromToken": fromToken,
    "toToken": toToken,
    "amount": amount,
    "caip2Id": "eip155:11155111",
    "slippage": 1,
  };
}
