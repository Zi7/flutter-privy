import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privyio/app_assets.dart';
import 'package:privyio/home_privy/home_privy_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
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

  void _navigateToWithdraw() {
    if (_currentUser == null) return;

    if (_currentUser!.embeddedEthereumWallets.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => WithdrawScreen(
              ethereumWallet: _currentUser!.embeddedEthereumWallets.first,
            ),
      ),
    );
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
          const Text(
            '\$0.00',
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
                    fontSize: 24,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _navigateToDeposit,
                  icon: const Icon(Icons.arrow_downward, size: 18),
                  label: const Text('Receive'),
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
        children: [
          _buildTransactionItem(
            type: 'Sent',
            amount: '\$10.0244',
            subAmount: '10.0174',
            isPositive: false,
          ),
          const Divider(height: 32),
          _buildTransactionItem(
            type: 'Received',
            amount: '\$9.9951',
            subAmount: '10.0174',
            isPositive: true,
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
  }) {
    return GestureDetector(
      onTap:
          () => _showTransactionDetail(
            type: type,
            amount: amount,
            subAmount: subAmount,
            isPositive: isPositive,
          ),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AppSvg.icUsdt(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      type,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Tether USD', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? const Color(0xFF26A17B) : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subAmount,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
  }) {
    final transaction = Transaction(
      type: type,
      amount: amount,
      subAmount: subAmount,
      isPositive: isPositive,
      assetName: 'Tether USD',
      assetSymbol: 'USDT',
      sentTo: '0xe8...ca76',
      blockchainFees: 'Free',
      network: 'BSC',
      date: '25 November, 2025 09:17 AM',
      status: 'completed',
      statusDescription:
          'Received your request to send 10.017396000000000000 Tether USD on BSC',
    );

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
              child: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}
