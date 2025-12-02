import 'package:get/get.dart';
import 'package:privyio/data/model/auth_models.dart';
import 'package:privyio/data/model/base_response.dart';
import 'package:privyio/data/model/create_tx_request.dart';
import 'package:privyio/data/model/create_tx_response.dart';
import 'package:privyio/data/model/prepare_swap.dart';
import 'package:privyio/data/model/user_profile.dart';
import 'package:privyio/data/model/wallet_balance.dart';
import 'package:privyio/utils/log.dart';

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

  // ==================== Smart Wallet Transaction ====================

  /// Get transactions
  /// GET /api/explorer/transactions
  Future<BaseResponse> getTransactions(String address) async {
    final queries = {'network': 'sepolia', 'address': address};
    final res = await get(Endpoints.getTransactions, query: queries);
    return BaseResponse.fromJson(res.body);
  }

  /// Get token transfers
  /// GET /api/explorer/token-transfers
  Future<BaseResponse> getTokenTransfers(String address) async {
    final queries = {'network': 'sepolia', 'address': address};
    final res = await get(Endpoints.getTokenTransfers, query: queries);
    return BaseResponse.fromJson(res.body);
  }

  /// Get internal transactions
  /// GET /api/explorer/internal-transactions
  Future<BaseResponse> getInternalTransactions(String address) async {
    final queries = {'network': 'sepolia', 'address': address};
    final res = await get(Endpoints.getInternalTransactions, query: queries);
    return BaseResponse.fromJson(res.body);
  }

  // ==================== Swap ====================

  /// Estimate swap
  /// POST /api/swap/estimate
  Future<BaseResponse> estimateSwap(PrepareSwap request) async {
    final res = await post(Endpoints.estimateSwap, request.toJson());
    return BaseResponse.fromJson(res.body);
  }

  /// Prepare swap
  /// POST /api/swap/prepare
  Future<CreateTxResponse> prepareSwap(PrepareSwap request) async {
    Log.i(request.toRawJson());
    final res = await post(Endpoints.prepareSwap, request.toJson());
    return CreateTxResponse.fromJson(res.body);
  }

  /// Swap
  /// POST /api/swap/send
  Future<BaseResponse> swap(String sessionId, String signature) async {
    final body = {"sessionId": sessionId, "signature": signature};
    final res = await post(Endpoints.swap, body);
    return BaseResponse.fromJson(res.body);
  }

  /// Create transaction
  /// POST /api/smart-wallet/create-tx
  Future<CreateTxResponse> createTx(CreateTxRequest request) async {
    final res = await post(Endpoints.createTx, request.toJson());
    return CreateTxResponse.fromJson(res.body);
  }

  /// Submit transaction
  /// POST /api/smart-wallet/submit-tx
  Future<BaseResponse> submitTx(String sessionId, String signature) async {
    final body = {"sessionId": sessionId, "signature": signature};
    final res = await post(Endpoints.submitTx, body);
    return BaseResponse.fromJson(res.body);
  }

  /// Get balance
  /// GET /api/explorer/balance
  Future<WalletBalance> getBalance(String address) async {
    final queries = {'address': address, 'network': 'sepolia'};
    final res = await get(Endpoints.getBalance, query: queries);
    return WalletBalance.fromJson(res.body);
  }
}
