import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privyio/app_assets.dart';
import 'package:privyio/data/model/transactions.dart';
import 'package:privyio/data/model/user_profile.dart';
import 'package:privyio/data/model/wallet_balance.dart';
import 'package:privyio/data/repositories/api_repo.dart';
import 'package:privyio/data/repositories/app_storage.dart';
import 'package:privyio/home/widgets/transaction_detail_bottom_sheet.dart';
import 'package:privyio/home_privy/home_privy_screen.dart';
import 'package:privyio/utils/number_util.dart';

import '../deposit/deposit_screen.dart';
import '../privy_manager.dart';
import '../swap/swap_screen.dart';
import '../withdraw/withdraw_screen.dart';

class HomeScreen extends StatefulWidget {
  final PrivyUser user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _privyManager = privyManager;
  List<Transaction>? _transactions;
  double? _totalBalance;
  WalletBalance? walletBalance;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    _loginApex();
  }

  _loginApex() async {
    try {
      if (widget.user.embeddedEthereumWallets.isEmpty) {
        await widget.user.createEthereumWallet();
      }
      if (widget.user.embeddedSolanaWallets.isEmpty) {
        await widget.user.createSolanaWallet();
      }
      final result = await widget.user.getAccessToken();
      result.fold(
        onSuccess: (value) async {
          final res = await ApiRepo.to.login(value);
          if (res.data.accessToken.isNotEmpty) {
            AppStorage().setString(SKeys.token, res.data.accessToken);
            _fetchData();
          }
        },
        onFailure: (error) {
          print(error);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  _fetchData() async {
    userProfile = await ApiRepo.to.getUserProfile();
    setState(() {});
    _fetchBalance();
    _fetchUserTransactions();
  }

  _fetchBalance() async {
    walletBalance = await ApiRepo.to.getBalance(userProfile!.data!.smartWallets!.first.id!);
    setState(() {
      _totalBalance = double.parse(walletBalance!.data!.native!.balanceFormatted ?? '0');
    });
  }

  _fetchUserTransactions() async {
    try {
      final res = await ApiRepo.to.getInternalTransactions(
        userProfile!.data!.smartWallets!.first.id!,
      );
      Future.delayed(const Duration(seconds: 1), () async {
        final res2 = await ApiRepo.to.getTransactions(userProfile!.data!.smartWallets!.first.id!);
        Future.delayed(const Duration(seconds: 1), () async {
          final res3 = await ApiRepo.to.getTokenTransfers(
            userProfile!.data!.smartWallets!.first.id!,
          );
          setState(() {
            _transactions = [...(res.data ?? []), ...(res2.data ?? []), ...(res3.data ?? [])];
            _transactions?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
          });
        });
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  void _navigateToSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => HomePrivyScreen(user: widget.user)));
  }

  void _navigateToDeposit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DepositScreen(address: userProfile!.data!.smartWallets!.first.address!),
      ),
    );
  }

  void _navigateToWithdraw() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => WithdrawScreen(
              id: userProfile!.data!.smartWallets!.first.id!,
              amount: walletBalance!.data!.native!.balanceFormatted ?? '0',
              ethereumWallet: widget.user.embeddedEthereumWallets.first,
            ),
      ),
    );
    _fetchData();
  }

  void _navigateToSwap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SwapScreen(
              ethereumWallet: widget.user.embeddedEthereumWallets.first,
              amount: double.parse(walletBalance!.data!.native!.balanceFormatted ?? '0'),
            ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await _privyManager.privy.logout();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${(_totalBalance ?? 0).formatDouble()}',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.add_circle_outline,
                label: 'Add Money',
                onTap: _navigateToDeposit,
              ),
              _buildActionButton(
                icon: Icons.arrow_upward,
                label: 'Withdraw',
                onTap: _navigateToWithdraw,
              ),
              _buildActionButton(icon: Icons.swap_horiz, label: 'Swap', onTap: _navigateToSwap),
              _buildActionButton(
                icon: Icons.settings,
                label: 'Settings',
                onTap: _navigateToSettings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDepositCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deposit Your\nFirst Token',
                  style: TextStyle(fontSize: 20, height: 1.4, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _navigateToDeposit,
                  icon: const Icon(Icons.arrow_downward, size: 14),
                  label: const Text('Receive', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.account_balance_wallet, size: 40, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_transactions == null)
            const Center(
              child: Padding(padding: EdgeInsets.all(30.0), child: CircularProgressIndicator()),
            )
          else if (_transactions!.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('No transactions yet', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions!.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final result = _transactions![index];

                return _buildTransactionItem(
                  assetName: result.symbol!,
                  type: result.type!,
                  amount: result.value!,
                  subAmount: result.value!,
                  status: _buildStatus(result.from, result.to, result.value),
                  isPositive: result.type == 'deposit',
                  transaction: result,
                );
              },
            ),
        ],
      ),
    );
  }

  _buildStatus(String? from, String? to, String? value) {
    if (from != null &&
        to != null &&
        value != null &&
        from.isNotEmpty &&
        to.isNotEmpty &&
        value != '0') {
      return 'Completed';
    }
    return 'Failed';
  }

  Widget _buildTransactionItem({
    required String assetName,
    required String type,
    required String amount,
    required String subAmount,
    required String status,
    required bool isPositive,
    required Transaction transaction,
  }) {
    return GestureDetector(
      onTap:
          () =>
              status == 'Completed'
                  ? _showTransactionDetail(
                    type: type,
                    amount: amount,
                    subAmount: subAmount,
                    isPositive: isPositive,
                    transaction: transaction,
                  )
                  : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AppSvg.icEth(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.cap0(), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                  assetName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${status == 'Completed' ? (isPositive ? '+' : '-') : ''}$amount $assetName',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      status == 'Completed'
                          ? (isPositive ? const Color(0xFF26A17B) : Colors.black)
                          : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Completed' ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: status == 'Completed' ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail({
    required String type,
    required String amount,
    required String subAmount,
    required bool isPositive,
    required Transaction transaction,
  }) {
    TransactionDetailBottomSheet.show(context, transaction: transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(() => _fetchData()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child:
                      _totalBalance != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Total Balance Card
                              _buildBalanceCard(),
                              const SizedBox(height: 16),

                              // Deposit First Token Card
                              _buildDepositCard(),
                              const SizedBox(height: 16),

                              // Transaction History
                              _buildTransactionHistory(),
                            ],
                          )
                          : const Center(child: CircularProgressIndicator()).paddingOnly(top: 300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
