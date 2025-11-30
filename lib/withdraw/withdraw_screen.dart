import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privyio/app_assets.dart';

class WithdrawScreen extends StatefulWidget {
  final EmbeddedEthereumWallet ethereumWallet;
  final double amount;

  const WithdrawScreen({
    super.key,
    required this.ethereumWallet,
    required this.amount,
  });

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      setState(() {
        _addressController.text = data!.text!;
      });
    }
  }

  Future<void> _sendTransaction() async {
    final amount = _amountController.text.trim();
    final toAddress = _addressController.text.trim();

    if (toAddress.isEmpty || amount.isEmpty) {
      _showMessage(
        "Please enter both recipient address and amount",
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
          _showMessage("Transaction sent! Hash: ${response.data.toString()}");
          _addressController.clear();
          _amountController.clear();
          Navigator.pop(context);
        },
        onFailure: (error) {
          _showMessage("Transaction failed: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      _showMessage("Transaction failed: $e", isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Withdraw Asset',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // ETH Balance Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    AppSvg.icEth(size: 40),
                    const SizedBox(width: 12),
                    const Text(
                      'ETH',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.amount}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Amount Input
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: '0.0',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Wallet Address Input
              const Text(
                'Wallet Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Type wallet address here',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.content_paste, size: 20),
                    onPressed: _pasteFromClipboard,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
