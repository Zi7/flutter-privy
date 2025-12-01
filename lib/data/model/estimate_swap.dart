import 'dart:convert';

class EstimateSwap {
  final String fromToken;
  final String toToken;
  final int amount;

  EstimateSwap({
    required this.fromToken,
    required this.toToken,
    required this.amount,
  });

  factory EstimateSwap.fromRawJson(String str) =>
      EstimateSwap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EstimateSwap.fromJson(Map<String, dynamic> json) => EstimateSwap(
    fromToken: json["fromToken"],
    toToken: json["toToken"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "fromToken": fromToken,
    "toToken": toToken,
    "amount": amount,
  };
}
