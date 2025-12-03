import 'dart:convert';
import 'dart:ffi';

class Transactions {
  final String? code;
  final String? message;
  final List<Transaction>? data;

  Transactions({this.code, this.message, this.data});

  factory Transactions.fromRawJson(String str) => Transactions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
    code: json["code"],
    message: json["message"],
    data:
        json["data"] == null || json["data"] is! Array
            ? []
            : List<Transaction>.from(json["data"]!.map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Transaction {
  final String? blockNumber;
  final String? timeStamp;
  final String? hash;
  final String? from;
  final String? to;
  final String? value;
  final String? contractAddress;
  final String? input;
  final String? type;
  final String? gas;
  final String? gasUsed;
  final String? traceId;
  final String? isError;
  final String? errCode;
  final String? symbol;

  Transaction({
    this.blockNumber,
    this.timeStamp,
    this.hash,
    this.from,
    this.to,
    this.value,
    this.contractAddress,
    this.input,
    this.type,
    this.gas,
    this.gasUsed,
    this.traceId,
    this.isError,
    this.errCode,
    this.symbol,
  });

  factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    blockNumber: json["blockNumber"],
    timeStamp: json["timeStamp"],
    hash: json["hash"],
    from: json["from"],
    to: json["to"],
    value: json["value"],
    contractAddress: json["contractAddress"],
    input: json["input"],
    type: json["type"],
    gas: json["gas"],
    gasUsed: json["gasUsed"],
    traceId: json["traceId"],
    isError: json["isError"],
    errCode: json["errCode"],
    symbol: json["symbol"],
  );

  Map<String, dynamic> toJson() => {
    "blockNumber": blockNumber,
    "timeStamp": timeStamp,
    "hash": hash,
    "from": from,
    "to": to,
    "value": value,
    "contractAddress": contractAddress,
    "input": input,
    "type": type,
    "gas": gas,
    "gasUsed": gasUsed,
    "traceId": traceId,
    "isError": isError,
    "errCode": errCode,
    "symbol": symbol,
  };
}
