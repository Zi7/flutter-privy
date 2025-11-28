class Transaction {
  final String type;
  final String amount;
  final String subAmount;
  final bool isPositive;
  final String assetName;
  final String assetSymbol;
  final String sentTo;
  final String blockchainFees;
  final String network;
  final String date;
  final String status;
  final String? statusDescription;

  const Transaction({
    required this.type,
    required this.amount,
    required this.subAmount,
    required this.isPositive,
    required this.assetName,
    required this.assetSymbol,
    required this.sentTo,
    required this.blockchainFees,
    required this.network,
    required this.date,
    required this.status,
    this.statusDescription,
  });
}
