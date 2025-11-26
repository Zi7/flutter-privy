import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';

import '../privy_manager.dart';
import 'widgets/ethereum_wallets_widget.dart';
import 'widgets/linked_accounts_widget.dart';
import 'widgets/solana_wallets_widget.dart';
import 'widgets/user_profile_widget.dart';

class HomeScreen extends StatefulWidget {
  final PrivyUser user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _privyManager = privyManager;
  PrivyUser? _currentUser;

  bool _isCreatingEthereumWallet = false;
  bool _isCreatingSolanaWallet = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _refreshUser() async {
    setState(() {});

    try {
      final result = await _privyManager.privy.getUser();
      if (result != null) {
        setState(() {
          _currentUser = result;
        });
      } else {
        setState(() {});
        _showMessage('Failed to refresh user data', isError: true);
      }
    } catch (e) {
      setState(() {});
      _showMessage('Error refreshing user: $e', isError: true);
    }
  }

  Future<void> _createEthereumWallet() async {
    setState(() {
      _isCreatingEthereumWallet = true;
    });

    try {
      final result = await _currentUser!.createEthereumWallet(
        allowAdditional: true,
      );

      result.fold(
        onSuccess: (wallet) {
          _showMessage("Ethereum wallet created: ${wallet.address}");
          setState(() {
            _isCreatingEthereumWallet = false;
          });
          _refreshUser();
        },
        onFailure: (error) {
          setState(() {
            _isCreatingEthereumWallet = false;
          });
          _showMessage(
            "Error creating wallet: ${error.message}",
            isError: true,
          );
        },
      );
    } catch (e) {
      setState(() {
        _isCreatingEthereumWallet = false;
      });
      _showMessage("Unexpected error: $e", isError: true);
    }
  }

  Future<void> _createSolanaWallet() async {
    setState(() {
      _isCreatingSolanaWallet = true;
    });

    try {
      final result = await _currentUser!.createSolanaWallet();

      result.fold(
        onSuccess: (wallet) {
          _showMessage("Solana wallet created: ${wallet.address}");
          setState(() {
            _isCreatingSolanaWallet = false;
          });
          _refreshUser();
        },
        onFailure: (error) {
          setState(() {
            _isCreatingSolanaWallet = false;
          });
          _showMessage(
            "Error creating wallet: ${error.message}",
            isError: true,
          );
        },
      );
    } catch (e) {
      setState(() {
        _isCreatingSolanaWallet = false;
      });
      _showMessage("Unexpected error: $e", isError: true);
    }
  }

  Future<void> _logout() async {
    try {
      await _privyManager.privy.logout();

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      _showMessage("Logout error: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_currentUser != null) ...[
                UserProfileWidget(user: _currentUser!),
                const Divider(),
                const SizedBox(height: 16),

                LinkedAccountsWidget(
                  user: _currentUser!,
                  onAccountLinked: _refreshUser,
                ),

                const SizedBox(height: 16),

                EthereumWalletsWidget(user: _currentUser!),

                const SizedBox(height: 24),

                SolanaWalletsWidget(user: _currentUser!),
                const SizedBox(height: 24),

                FloatingActionButton.extended(
                  heroTag: "createEthereum",
                  onPressed:
                      (_isCreatingEthereumWallet || _isCreatingSolanaWallet)
                          ? null
                          : _createEthereumWallet,
                  icon:
                      _isCreatingEthereumWallet
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : null,
                  label: const Text('Create ETH Wallet'),
                  backgroundColor:
                      (_isCreatingEthereumWallet || _isCreatingSolanaWallet)
                          ? Colors.grey
                          : null,
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: "createSolana",
                  onPressed:
                      (_isCreatingSolanaWallet || _isCreatingEthereumWallet)
                          ? null
                          : _createSolanaWallet,
                  icon:
                      _isCreatingSolanaWallet
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : null,
                  label: const Text('Create SOL Wallet'),
                  backgroundColor:
                      (_isCreatingSolanaWallet || _isCreatingEthereumWallet)
                          ? Colors.grey
                          : null,
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: "logout",
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  backgroundColor: Colors.redAccent,
                ),
              ] else ...[
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
