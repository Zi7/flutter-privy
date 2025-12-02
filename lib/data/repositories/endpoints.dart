final class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://demo-new-flow.eachop.tech/api';

  // Authentication
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';

  // Users
  static const String getUserProfile = '/users/me';

  //  Transaction
  static const String getTransactions = '/explorer/transactions';
  static const String getTokenTransfers = '/explorer/token-transfers';
  static const String getInternalTransactions =
      '/explorer/internal-transactions';

  // Tx
  static const String estimateSwap = '/swap/estimate';
  static const String prepareSwap = '/swap/prepare';
  static const String swap = '/swap/send';
  static const String createTx = '/smart-wallet/create-tx';
  static const String submitTx = '/smart-wallet/submit-tx';

  // Balance
  static const String getBalance = '/explorer/balance';
}
