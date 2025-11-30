import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privyio/app_assets.dart';
import 'package:privyio/data/model/transaction_models.dart' as api_models;
import 'package:privyio/data/model/user_models.dart' show WalletBalance;
import 'package:privyio/data/repositories/api_repo.dart';
import 'package:privyio/data/repositories/app_storage.dart';
import 'package:privyio/home_privy/home_privy_screen.dart';
import 'package:privyio/utils/number_util.dart';

import '../deposit/deposit_screen.dart';
import '../privy_manager.dart';
import '../swap/swap_screen.dart';
import '../withdraw/withdraw_screen.dart';
import 'models/transaction.dart';
import 'widgets/transaction_detail_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final PrivyUser user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _privyManager = privyManager;
  PrivyUser? _currentUser;
  List<api_models.Transaction> _transactions = [];
  double _totalBalance = 0;
  WalletBalance? ethWallet;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _loginApex();
  }

  _loginApex() async {
    try {
      final result = await _currentUser!.getAccessToken();
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
    _fetchBalance();
    _fetchUserTransactions();
  }

  _fetchBalance() async {
    ethWallet = await ApiRepo.to.getWalletBalance(
      walletId: _currentUser!.embeddedEthereumWallets.first.id!,
      asset: 'eth',
      chain: 'sepolia',
    );
    final res2 = await ApiRepo.to.getWalletBalance(
      walletId: _currentUser!.embeddedSolanaWallets.first.id!,
      asset: 'sol',
      chain: 'solana_devnet',
    );
    setState(() {
      _totalBalance =
          _doubleOf(ethWallet?.data!.balances!.first.displayValues!.usd) +
          _doubleOf(res2.data!.balances!.first.displayValues!.usd);
    });
  }

  _doubleOf(String? value) {
    return double.tryParse(value ?? '0') ?? 0;
  }

  _fetchUserTransactions() async {
    try {
      final res = await ApiRepo.to.getTransactionsFromPrivy(
        walletId: _currentUser!.embeddedEthereumWallets.first.id!,
        asset: 'eth',
        chain: 'sepolia',
      );

      if (res.data != null && res.data!.transactions != null) {
        setState(() {
          _transactions = res.data!.transactions!;
        });
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomePrivyScreen(user: _currentUser!),
      ),
    );
  }

  void _navigateToDeposit() {
    if (_currentUser == null) return;

    // Get first wallet of each type if available
    EmbeddedEthereumWallet? ethWallet;
    EmbeddedSolanaWallet? solWallet;

    if (_currentUser!.embeddedEthereumWallets.isNotEmpty) {
      ethWallet = _currentUser!.embeddedEthereumWallets.first;
    }

    if (_currentUser!.embeddedSolanaWallets.isNotEmpty) {
      solWallet = _currentUser!.embeddedSolanaWallets.first;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DepositScreen(
              ethereumWallet: ethWallet,
              solanaWallet: solWallet,
            ),
      ),
    );
  }

  void _navigateToWithdraw() async {
    if (_currentUser == null) return;

    if (_currentUser!.embeddedEthereumWallets.isEmpty) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => WithdrawScreen(
              ethereumWallet: _currentUser!.embeddedEthereumWallets.first,
              amount: _doubleOf(
                ethWallet?.data!.balances!.first.displayValues!.eth,
              ),
            ),
      ),
    );
    _fetchData();
  }

  void _navigateToSwap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SwapScreen()),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_totalBalance.formatDouble()}',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
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
              _buildActionButton(
                icon: Icons.swap_horiz,
                label: 'Swap',
                onTap: _navigateToSwap,
              ),
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
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
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
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _navigateToDeposit,
                  icon: const Icon(Icons.arrow_downward, size: 14),
                  label: const Text('Receive', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 40,
              color: Colors.white,
            ),
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
          if (_transactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No transactions yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                final details = transaction.details;
                final isReceived = details?.type == 'transfer_received';

                return _buildTransactionItem(
                  type: isReceived ? 'Received' : 'Sent',
                  amount: details?.displayValues?.eth ?? '0',
                  subAmount: details?.rawValue ?? '0',
                  isPositive: isReceived,
                  transaction: transaction,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String type,
    required String amount,
    required String subAmount,
    required bool isPositive,
    api_models.Transaction? transaction,
  }) {
    final assetName = transaction?.details?.asset?.toUpperCase() ?? 'ETH';
    final status = transaction?.status ?? 'completed';

    return GestureDetector(
      onTap:
          () => _showTransactionDetail(
            type: type,
            amount: amount,
            subAmount: subAmount,
            isPositive: isPositive,
            transaction: transaction,
          ),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AppSvg.icEth(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
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
                '${isPositive ? '+' : '-'}$amount $assetName',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isPositive ? const Color(0xFF26A17B) : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      status == 'completed'
                          ? Colors.green[50]
                          : Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        status == 'completed'
                            ? Colors.green[700]
                            : Colors.orange[700],
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
    api_models.Transaction? transaction,
  }) {
    final assetName = transaction?.details?.asset?.toUpperCase() ?? 'ETH';

    final localTransaction = Transaction(
      type: type,
      amount: amount,
      subAmount: subAmount,
      isPositive: isPositive,
      assetName: assetName,
      assetSymbol: assetName,
      fromTo:
          isPositive
              ? (transaction?.details?.sender ?? 'Unknown')
              : (transaction?.details?.recipient ?? 'Unknown'),
      blockchainFees: 'Network fees',
      network: transaction?.details?.chain ?? 'Sepolia',
      date:
          transaction?.createdAt != null
              ? DateTime.fromMillisecondsSinceEpoch(
                transaction!.createdAt!,
              ).toString().replaceAll('.000', '')
              : 'Unknown',
      status: transaction?.status ?? 'completed',
      statusDescription:
          '${isPositive ? 'Received' : 'Sent'} $amount $assetName',
      url: 'https://sepolia.etherscan.io/tx/${transaction?.transactionHash}',
    );

    TransactionDetailBottomSheet.show(context, transaction: localTransaction);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_currentUser != null) ...[
                        // Total Balance Card
                        _buildBalanceCard(),
                        const SizedBox(height: 16),

                        // Deposit First Token Card
                        _buildDepositCard(),
                        const SizedBox(height: 16),

                        // Transaction History
                        _buildTransactionHistory(),
                      ] else ...[
                        const Center(child: CircularProgressIndicator()),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
