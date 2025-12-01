import 'dart:convert';

class SwapModel {
  final String jwt;
  final String fromToken;
  final String toToken;
  final int amount;
  final String caip2Id;
  final int slippage;

  SwapModel({
    required this.jwt,
    required this.fromToken,
    required this.toToken,
    required this.amount,
    required this.caip2Id,
    required this.slippage,
  });

  factory SwapModel.fromRawJson(String str) =>
      SwapModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SwapModel.fromJson(Map<String, dynamic> json) => SwapModel(
    jwt: json["jwt"],
    fromToken: json["fromToken"],
    toToken: json["toToken"],
    amount: json["amount"],
    caip2Id: json["caip2Id"],
    slippage: json["slippage"],
  );

  Map<String, dynamic> toJson() => {
    "jwt": jwt,
    "fromToken": fromToken,
    "toToken": toToken,
    "amount": amount,
    "caip2Id": caip2Id,
    "slippage": slippage,
  };
}
