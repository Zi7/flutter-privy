import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privyio/data/model/prepare_swap.dart';
import 'package:privyio/data/repositories/api_repo.dart';
import 'package:privyio/utils/number_util.dart';

import '../app_assets.dart';
import '../data/model/asset.dart';

class SwapScreen extends StatefulWidget {
  final EmbeddedEthereumWallet ethereumWallet;

  const SwapScreen({super.key, required this.ethereumWallet});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final TextEditingController _amountController = TextEditingController();
  Asset? _fromAsset;
  Asset? _toAsset;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default from asset to SOL
    _fromAsset = Asset(
      name: 'USDC',
      symbol: 'USDC',
      balance: 10002,
      icon: AppSvg.icUsdc(size: 24),
      iconLarge: AppSvg.icUsdc(size: 40),
      address: '0xbA386FB039f7d35BE74214e88aBe9D0d055139Bd',
    );
    _toAsset = Asset(
      name: 'Binance',
      symbol: 'BNB',
      balance: 139.13,
      icon: AppSvg.icBsc(size: 24), // Placeholder
      iconLarge: AppSvg.icBsc(size: 40),
      address: '0xae13d989dac2f0debff460ac112a837c89baa7cd',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showAssetSelector({required bool isFromAsset}) {
    // SelectAssetBottomSheet.show(
    //   context,
    //   assets: _availableAssets,
    //   onAssetSelected: (asset) {
    //     setState(() {
    //       if (isFromAsset) {
    //         _fromAsset = asset;
    //       } else {
    //         _toAsset = asset;
    //       }
    //     });
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Multichain',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Asset selection row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // From asset selector
                Expanded(
                  child: _buildAssetSelector(
                    asset: _fromAsset,
                    placeholder: 'Select Asset',
                    onTap: () => _showAssetSelector(isFromAsset: true),
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow icon
                GestureDetector(
                  onTap: _switchToken,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.swap_horizontal_circle,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // To asset selector
                Expanded(
                  child: _buildAssetSelector(
                    asset: _toAsset,
                    placeholder: 'Select Asset',
                    onTap: () => _showAssetSelector(isFromAsset: false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Amount input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_fromAsset != null) _fromAsset!.iconLarge,
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.none,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                    decoration: const InputDecoration(
                      hintText: '0.00000',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Current balance
          if (_fromAsset != null)
            Text(
              'Current Balance: ${_fromAsset!.symbol} ${_fromAsset!.balance.formatDouble()}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          const Spacer(),
          // Continue button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _swapToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
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
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Percentage buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildPercentageButton('25%'),
                const SizedBox(width: 8),
                _buildPercentageButton('50%'),
                const SizedBox(width: 8),
                _buildPercentageButton('75%'),
                const SizedBox(width: 8),
                _buildPercentageButton('100%'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Custom numpad
          _buildNumpad(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildAssetSelector({
    required Asset? asset,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (asset != null) ...[
              asset.icon,
              const SizedBox(width: 8),
              Text(
                asset.symbol,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else
              Text(
                placeholder,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            // const SizedBox(width: 4),
            // const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageButton(String text) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            children: [
              _buildNumpadKey('1'),
              _buildNumpadKey('2'),
              _buildNumpadKey('3'),
            ],
          ),
          Row(
            children: [
              _buildNumpadKey('4'),
              _buildNumpadKey('5'),
              _buildNumpadKey('6'),
            ],
          ),
          Row(
            children: [
              _buildNumpadKey('7'),
              _buildNumpadKey('8'),
              _buildNumpadKey('9'),
            ],
          ),
          Row(
            children: [
              _buildNumpadKey('.'),
              _buildNumpadKey('0'),
              _buildNumpadKey('⌫', isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadKey(String text, {bool isBackspace = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () {
            if (isBackspace) {
              if (_amountController.text.isNotEmpty) {
                _amountController.text = _amountController.text.substring(
                  0,
                  _amountController.text.length - 1,
                );
              }
            } else {
              _amountController.text += text;
            }
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _switchToken() {
    final temp = _fromAsset;
    _fromAsset = _toAsset;
    _toAsset = temp;
    _amountController.clear();
    setState(() {});
  }

  void _swapToken() async {
    if (_amountController.text.isEmpty) {
      _showMessage("Amount is required", isError: true);
      return;
    }
    if (double.parse(_amountController.text) > _fromAsset!.balance) {
      _showMessage("Insufficient balance", isError: true);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final res = await ApiRepo.to.prepareSwap(
      PrepareSwap(
        fromToken: _fromAsset!.address,
        toToken: _toAsset!.address,
        amount: double.parse(_amountController.text),
      ),
    );
    if (res.message == "success") {
      _secp256k1Sign(res.data!.dataHash!, res.data!.sessionToSubmit!);
    } else {
      _showMessage(res.message ?? "Swap failed", isError: true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _secp256k1Sign(String dataHash, String sessionId) async {
    try {
      final request = EthereumRpcRequest.secp256k1Sign(dataHash);
      final result = await widget.ethereumWallet.provider.request(request);

      result.fold(
        onSuccess: (response) async {
          final signature = response.data.toString();
          final res = await ApiRepo.to.swap(sessionId, signature);
          setState(() {
            _isLoading = false;
          });
          if (res.message == "success") {
            _showMessage("Swap successful");
            Navigator.pop(context);
          } else {
            _showMessage(res.message, isError: true);
          }
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
}
