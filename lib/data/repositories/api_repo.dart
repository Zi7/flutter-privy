import 'package:get/get.dart';
import 'package:privyio/data/model/auth_models.dart';
import 'package:privyio/data/model/base_response.dart';
import 'package:privyio/data/model/currency_models.dart';
import 'package:privyio/data/model/transaction_models.dart';
import 'package:privyio/data/model/user_models.dart';

import 'base_repository.dart';
import 'endpoints.dart';

final class ApiRepo extends BaseRepository {
  static ApiRepo get to => Get.find();

  // ==================== Authentication ====================

  /// Login with Privy token
  /// POST /api/auth/login
  Future<AuthResponse> login(String privyToken) async {
    final request = LoginRequest(token: privyToken);
    final res = await post(Endpoints.login, request.toJson());
    return AuthResponse.fromJson(res.body);
  }

  /// Refresh access token
  /// POST /api/auth/refresh
  Future<AuthResponse> refreshToken(String refreshToken) async {
    final request = RefreshTokenRequest(refreshToken: refreshToken);
    final res = await post(Endpoints.refresh, request.toJson());
    return AuthResponse.fromJson(res.body);
  }

  // ==================== Users ====================

  /// Get current user profile
  /// GET /api/users/me
  Future<UserProfile> getUserProfile() async {
    final res = await get(Endpoints.getUserProfile);
    return UserProfile.fromJson(res.body);
  }

  // ==================== Privy User ====================

  /// Get all linked Privy accounts
  /// GET /api/privy/users
  Future<List<PrivyUser>> getPrivyUsers() async {
    final res = await get(Endpoints.getPrivyUsers);
    return (res.body as List).map((e) => PrivyUser.fromJson(e)).toList();
  }

  /// Get wallet balance
  /// GET /api/privy/users/balance
  ///
  /// Parameters:
  /// - [walletId]: Privy wallet ID
  /// - [asset]: Asset to query balance for (usdc, eth, pol, usdt, sol)
  /// - [chain]: Chain to query balance on
  Future<WalletBalance> getWalletBalance({
    required String walletId,
    required String asset,
    required String chain,
  }) async {
    final res = await get(
      Endpoints.getWalletBalance,
      query: {'walletId': walletId, 'asset': asset, 'chain': chain},
    );
    return WalletBalance.fromJson(res.body);
  }

  // ==================== Privy Transaction ====================

  /// Get transactions from Privy API
  /// GET /api/privy/transactions/from-privy
  ///
  /// Parameters:
  /// - [walletId]: Privy wallet ID
  /// - [asset]: Asset to query (usdc, eth, pol, usdt, sol)
  /// - [chain]: Chain to query
  /// - [limit]: Maximum number of transactions to return (default: 50)
  Future<PrivyTransactionsResponse> getTransactionsFromPrivy({
    required String walletId,
    required String asset,
    required String chain,
    int limit = 50,
  }) async {
    final res = await get(
      Endpoints.getTransactionsFromPrivy,
      query: {
        'walletId': walletId,
        'asset': asset,
        'chain': chain,
        'limit': limit.toString(),
      },
    );
    return PrivyTransactionsResponse.fromJson(res.body);
  }

  // Future<UserTransactionsResponse> getUserTransactions({
  //   int perPage = 50,
  //   int page = 1,
  //   String? startDate,
  //   String? endDate,
  //   String? search,
  //   String? privyWalletId,
  //   String? type,
  //   String? chain,
  //   String? asset,
  //   int? limit,
  // }) async {
  //   final query = <String, dynamic>{
  //     'perPage': perPage.toString(),
  //     'page': page.toString(),
  //   };

  //   if (startDate != null) query['startDate'] = startDate;
  //   if (endDate != null) query['endDate'] = endDate;
  //   if (search != null) query['search'] = search;
  //   if (privyWalletId != null) query['privyWalletId'] = privyWalletId;
  //   if (type != null) query['type'] = type;
  //   if (chain != null) query['chain'] = chain;
  //   if (asset != null) query['asset'] = asset;
  //   if (limit != null) query['limit'] = limit.toString();

  //   final res = await get(Endpoints.getUserTransactions, query: query);
  //   return UserTransactionsResponse.fromJson(res.body);
  // }

  /// Get transaction by ID
  /// GET /api/privy/transactions/:id
  Future<BaseResponse> getTransactionById(String transactionId) async {
    final res = await get(Endpoints.getTransactionById(transactionId));
    return BaseResponse.fromJson(res.body);
  }

  // ==================== Currency ====================

  /// Get all currencies
  /// GET /api/currency/currencies
  Future<List<Currency>> getAllCurrencies() async {
    final res = await get(Endpoints.getAllCurrencies);
    return (res.body as List).map((e) => Currency.fromJson(e)).toList();
  }

  /// Get currency by symbol
  /// GET /api/currency/currencies/:symbol
  ///
  /// Parameters:
  /// - [symbol]: Currency symbol (e.g., ETH, USDC)
  Future<Currency> getCurrencyBySymbol(String symbol) async {
    final res = await get(Endpoints.getCurrencyBySymbol(symbol));
    return Currency.fromJson(res.body);
  }

  // ==================== Legacy ====================

  /// Get all categories (legacy endpoint)
  /// GET /app/category
  Future<BaseResponse> getAllCategories(String storeCode) async {
    final res = await get(
      Endpoints.getAllCategories,
      query: {'qrcode': storeCode},
    );
    return BaseResponse.fromJson(res.body);
  }
}
