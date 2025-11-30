final class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://demo-new-flow.eachop.tech/api';
  
  // Authentication
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  
  // Users
  static const String getUserProfile = '/users/me';
  
  // Privy User
  static const String getPrivyUsers = '/privy/users';
  static const String getWalletBalance = '/privy/users/balance';
  
  // Privy Transaction
  static const String getTransactionsFromPrivy = '/privy/transactions/from-privy';
  static const String getUserTransactions = '/privy/transactions';
  static String getTransactionById(String id) => '/privy/transactions/$id';
  
  // Currency
  static const String getAllCurrencies = '/currency/currencies';
  static String getCurrencyBySymbol(String symbol) => '/currency/currencies/$symbol';
  
  // Legacy
  static const String getAllCategories = '/app/category';
}
