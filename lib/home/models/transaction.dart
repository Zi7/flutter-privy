class Transaction {
  final String type;
  final String amount;
  final String subAmount;
  final bool isPositive;
  final String assetName;
  final String assetSymbol;
  final String fromTo;
  final String blockchainFees;
  final String network;
  final String date;
  final String status;
  final String? statusDescription;
  final String url;

  const Transaction({
    required this.type,
    required this.amount,
    required this.subAmount,
    required this.isPositive,
    required this.assetName,
    required this.assetSymbol,
    required this.fromTo,
    required this.blockchainFees,
    required this.network,
    required this.date,
    required this.status,
    this.statusDescription,
    required this.url,
  });
}
