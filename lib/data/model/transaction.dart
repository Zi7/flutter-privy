import 'dart:convert';

class Transaction {
  final String? code;
  final String? message;
  final Data? data;

  Transaction({this.code, this.message, this.data});

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
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
  final String? status;
  final String? message;
  final List<Result>? result;

  Data({this.status, this.message, this.result});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    message: json["message"],
    result:
        json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result":
        result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  final String? blockNumber;
  final String? timeStamp;
  final String? hash;
  final String? nonce;
  final String? blockHash;
  final String? transactionIndex;
  final String? from;
  final String? to;
  final String? value;
  final String? gas;
  final String? gasPrice;
  final String? isError;
  final String? txreceiptStatus;
  final String? input;
  final String? contractAddress;
  final String? cumulativeGasUsed;
  final String? gasUsed;
  final String? confirmations;
  final String? methodId;
  final String? functionName;

  Result({
    this.blockNumber,
    this.timeStamp,
    this.hash,
    this.nonce,
    this.blockHash,
    this.transactionIndex,
    this.from,
    this.to,
    this.value,
    this.gas,
    this.gasPrice,
    this.isError,
    this.txreceiptStatus,
    this.input,
    this.contractAddress,
    this.cumulativeGasUsed,
    this.gasUsed,
    this.confirmations,
    this.methodId,
    this.functionName,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    blockNumber: json["blockNumber"],
    timeStamp: json["timeStamp"],
    hash: json["hash"],
    nonce: json["nonce"],
    blockHash: json["blockHash"],
    transactionIndex: json["transactionIndex"],
    from: json["from"],
    to: json["to"],
    value: json["value"],
    gas: json["gas"],
    gasPrice: json["gasPrice"],
    isError: json["isError"],
    txreceiptStatus: json["txreceipt_status"],
    input: json["input"],
    contractAddress: json["contractAddress"],
    cumulativeGasUsed: json["cumulativeGasUsed"],
    gasUsed: json["gasUsed"],
    confirmations: json["confirmations"],
    methodId: json["methodId"],
    functionName: json["functionName"],
  );

  Map<String, dynamic> toJson() => {
    "blockNumber": blockNumber,
    "timeStamp": timeStamp,
    "hash": hash,
    "nonce": nonce,
    "blockHash": blockHash,
    "transactionIndex": transactionIndex,
    "from": from,
    "to": to,
    "value": value,
    "gas": gas,
    "gasPrice": gasPrice,
    "isError": isError,
    "txreceipt_status": txreceiptStatus,
    "input": input,
    "contractAddress": contractAddress,
    "cumulativeGasUsed": cumulativeGasUsed,
    "gasUsed": gasUsed,
    "confirmations": confirmations,
    "methodId": methodId,
    "functionName": functionName,
  };
}
