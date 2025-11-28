import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositScreen extends StatefulWidget {
  final EmbeddedEthereumWallet? ethereumWallet;
  final EmbeddedSolanaWallet? solanaWallet;

  const DepositScreen({super.key, this.ethereumWallet, this.solanaWallet});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  String _selectedNetwork = 'Solana';

  @override
  void initState() {
    super.initState();
    // Set default network based on available wallets
    if (widget.solanaWallet != null) {
      _selectedNetwork = 'Solana';
    } else if (widget.ethereumWallet != null) {
      _selectedNetwork = 'EVM';
    }
  }

  String get _currentAddress {
    if (_selectedNetwork == 'Solana' && widget.solanaWallet != null) {
      return widget.solanaWallet!.address;
    } else if (_selectedNetwork == 'EVM' && widget.ethereumWallet != null) {
      return widget.ethereumWallet!.address;
    }
    return '';
  }

  void _copyAddress() {
    if (_currentAddress.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _currentAddress));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address copied to clipboard'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
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
                'Receive Crypto',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Deposit any of your assets from other wallets to Avici. Send only to the networks selected',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Network selector
              _buildNetworkSelector(),

              const SizedBox(height: 12),

              // QR Code and Address Card
              Expanded(child: Center(child: _buildQRCard())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.solanaWallet != null)
          _buildNetworkChip('Solana', Icons.circle),
        if (widget.solanaWallet != null && widget.ethereumWallet != null)
          const SizedBox(width: 12),
        if (widget.ethereumWallet != null)
          _buildNetworkChip('EVM', Icons.hexagon),
      ],
    );
  }

  Widget _buildNetworkChip(String network, IconData icon) {
    final isSelected = _selectedNetwork == network;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNetwork = network;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              network,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCard() {
    if (_currentAddress.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
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
        child: const Text(
          'No wallet available for this network',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(32),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: _currentAddress,
              version: QrVersions.auto,
              size: 250,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Colors.black,
              ),
            ),
          ),

          // Address
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Copy Button
          ElevatedButton.icon(
            onPressed: _copyAddress,
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
