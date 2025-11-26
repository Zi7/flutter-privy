import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privy_flutter/privy_flutter.dart';

class EthWalletScreen extends StatefulWidget {
  final EmbeddedEthereumWallet ethereumWallet;

  const EthWalletScreen({super.key, required this.ethereumWallet});

  @override
  State<EthWalletScreen> createState() => _EthWalletScreenState();
}

class _EthWalletScreenState extends State<EthWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toAddressController = TextEditingController();

  static String get _authenticationMessage =>
      "Sign this message to authenticate with Example App\n"
      "Domain: example.com\n"
      "Nonce: ${DateTime.now().millisecondsSinceEpoch}\n"
      "Chain ID: 11155111";

  static const String _simpleMessage = "Hello";

  String? _latestSignature;
  String? _signedTransaction;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _toAddressController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  String _encodeMessage(String message) {
    return "0x${utf8.encode(message).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}";
  }

  Future<void> _signEthereumMessage() async {
    try {
      final encodedMessage = _encodeMessage(_authenticationMessage);
      final rpcRequest = EthereumRpcRequest.personalSign(
        encodedMessage,
        widget.ethereumWallet.address,
      );
      final result = await widget.ethereumWallet.provider.request(rpcRequest);

      result.fold(
        onSuccess: (response) {
          final signature = response.data.toString();
          setState(() {
            _latestSignature = signature;
          });
          _showMessage("Personal sign: $signature");
        },
        onFailure: (error) {
          _showMessage("Personal sign failed: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      _showMessage("Signing error: $e", isError: true);
    }
  }

  Future<void> _signSimpleMessage() async {
    try {
      final encodedMessage = _encodeMessage(_simpleMessage);
      final request = EthereumRpcRequest.ethSign(
        widget.ethereumWallet.address,
        encodedMessage,
      );
      final result = await widget.ethereumWallet.provider.request(request);

      result.fold(
        onSuccess: (response) {
          final signature = response.data.toString();
          setState(() {
            _latestSignature = signature;
          });
          _showMessage("Eth sign: $signature");
        },
        onFailure: (error) {
          _showMessage("Eth sign failed: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      _showMessage("Eth sign error: $e", isError: true);
    }
  }

  Future<void> _secp256k1Sign() async {
    try {
      const dataHash =
          "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";
      final request = EthereumRpcRequest.secp256k1Sign(dataHash);
      final result = await widget.ethereumWallet.provider.request(request);

      result.fold(
        onSuccess: (response) {
          final signature = response.data.toString();
          setState(() {
            _latestSignature = signature;
          });
          _showMessage("Secp256k1 sign: $signature");
        },
        onFailure: (error) {
          _showMessage(
            "Secp256k1 sign failed: ${error.message}",
            isError: true,
          );
        },
      );
    } catch (e) {
      _showMessage("Secp256k1 sign error: $e", isError: true);
    }
  }

  Future<void> _signTypedData() async {
    try {
      final payload = {
        "types": {
          "EIP712Domain": [
            {"name": "name", "type": "string"},
            {"name": "version", "type": "string"},
            {"name": "chainId", "type": "uint256"},
            {"name": "verifyingContract", "type": "address"},
          ],
          "Person": [
            {"name": "name", "type": "string"},
            {"name": "wallet", "type": "address"},
          ],
          "Mail": [
            {"name": "from", "type": "Person"},
            {"name": "to", "type": "Person"},
            {"name": "contents", "type": "string"},
          ],
        },
        "primaryType": "Mail",
        "domain": {
          "name": "Example App",
          "version": "1",
          "chainId": "0xAA36A7",
          "verifyingContract": "0x0000000000000000000000000000000000000000",
        },
        "message": {
          "from": {"name": "User1", "wallet": widget.ethereumWallet.address},
          "to": {
            "name": "User2",
            "wallet": "0x1111111111111111111111111111111111111111",
          },
          "contents": "Hello User2!",
        },
      };

      final request = EthereumRpcRequest.ethSignTypedDataV4(
        widget.ethereumWallet.address,
        jsonEncode(payload),
      );
      final result = await widget.ethereumWallet.provider.request(request);

      result.fold(
        onSuccess: (response) {
          final signature = response.data.toString();
          setState(() {
            _latestSignature = signature;
          });
          _showMessage("Sign typed data: $signature");
        },
        onFailure: (error) {
          _showMessage(
            "Sign typed data failed: ${error.message}",
            isError: true,
          );
        },
      );
    } catch (e) {
      _showMessage("Sign typed data error: $e", isError: true);
    }
  }

  Future<void> _signTransaction() async {
    final amount = _amountController.text.trim();
    final toAddress = _toAddressController.text.trim();

    if (toAddress.isEmpty || amount.isEmpty) {
      _showMessage(
        "Please enter both recipient address and amount",
        isError: true,
      );
      return;
    }

    try {
      BigInt weiAmount = BigInt.parse(
        (double.parse(amount) * 1e18).toStringAsFixed(0),
      );
      String weiHex = "0x${weiAmount.toRadixString(16)}";

      final txPayload = {
        "from": widget.ethereumWallet.address,
        "to": toAddress,
        "value": weiHex,
        "chainId": "0xAA36A7",
        "gasLimit": "0x5208",
        "maxPriorityFeePerGas": "0x3B9ACA00",
        "maxFeePerGas": "0x77359400",
      };

      final request = EthereumRpcRequest.ethSignTransaction(
        jsonEncode(txPayload),
      );
      final result = await widget.ethereumWallet.provider.request(request);

      result.fold(
        onSuccess: (response) {
          final signedTx = response.data.toString();
          setState(() {
            _signedTransaction = signedTx;
          });
          _showMessage("Signed Transaction: $signedTx");
        },
        onFailure: (error) {
          _showMessage(
            "Transaction signing failed: ${error.message}",
            isError: true,
          );
        },
      );
    } catch (e) {
      _showMessage("Transaction signing failed: $e", isError: true);
    }
  }

  Future<void> _sendTransaction() async {
    final amount = _amountController.text.trim();
    final toAddress = _toAddressController.text.trim();

    if (toAddress.isEmpty || amount.isEmpty) {
      _showMessage(
        "Please enter both recipient address and amount",
        isError: true,
      );
      return;
    }

    try {
      BigInt weiAmount = BigInt.parse(
        (double.parse(amount) * 1e18).toStringAsFixed(0),
      );
      String weiHex = "0x${weiAmount.toRadixString(16)}";

      final txPayload = {
        "from": widget.ethereumWallet.address,
        "to": toAddress,
        "value": weiHex,
        "chainId": "0xAA36A7",
        "gasLimit": "0x5208",
        "maxPriorityFeePerGas": "0x3B9ACA00",
        "maxFeePerGas": "0x77359400",
      };

      final request = EthereumRpcRequest.ethSendTransaction(
        jsonEncode(txPayload),
      );
      final result = await widget.ethereumWallet.provider.request(request);

      result.fold(
        onSuccess: (response) {
          print("Transaction sent! Hash: ${response.data.toString()}");
          _showMessage("Transaction sent! Hash: ${response.data.toString()}");
        },
        onFailure: (error) {
          _showMessage("Transaction failed: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      _showMessage("Transaction failed: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const String walletType = 'Ethereum';
    final String address = widget.ethereumWallet.address;
    final String? recoveryMethod = widget.ethereumWallet.recoveryMethod;
    final int hdWalletIndex = widget.ethereumWallet.hdWalletIndex;
    final String? chainId = widget.ethereumWallet.chainId;

    return Scaffold(
      appBar: AppBar(
        title: Text('$walletType Wallet Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      '$walletType Wallet',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    _showMessage('Address copied to clipboard!');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                address,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.copy, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (chainId != null && chainId.isNotEmpty)
                  _buildDetailItem(context, 'Chain ID', chainId),
                if (recoveryMethod != null && recoveryMethod.isNotEmpty)
                  _buildDetailItem(context, 'Recovery Method', recoveryMethod),
                _buildDetailItem(
                  context,
                  'HD Wallet Index',
                  hdWalletIndex.toString(),
                ),

                const SizedBox(height: 32),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: _signEthereumMessage,
                      child: const Text('Personal Sign'),
                    ),
                    ElevatedButton(
                      onPressed: _signSimpleMessage,
                      child: const Text('Eth Sign'),
                    ),
                    ElevatedButton(
                      onPressed: _secp256k1Sign,
                      child: const Text('Secp256k1 Sign'),
                    ),
                    ElevatedButton(
                      onPressed: _signTypedData,
                      child: const Text('Sign Typed Data'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text(
                  'Send Transaction',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _toAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient Address',
                    hintText: '0x...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (ETH)',
                    hintText: '0.001',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _signTransaction,
                        child: const Text('Sign Transaction'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _sendTransaction,
                        child: const Text('Send Transaction'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                if (_latestSignature != null || _signedTransaction != null) ...[
                  Text(
                    'Results',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_latestSignature != null)
                    _buildResultCard(
                      context,
                      'Latest Signature',
                      _latestSignature!,
                    ),

                  if (_signedTransaction != null)
                    _buildResultCard(
                      context,
                      'Signed Transaction',
                      _signedTransaction!,
                    ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  _showMessage('$title copied to clipboard!');
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            content,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ],
      ),
    );
  }
}
