import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:privyio/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/transaction.dart';

class TransactionDetailBottomSheet extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailBottomSheet({super.key, required this.transaction});

  static Future<void> show(
    BuildContext context, {
    required Transaction transaction,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionDetailBottomSheet(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Text(
            transaction.isPositive ? 'Received' : 'Sent',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          // Amount with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.amount,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              AppSvg.icEth(size: 32),
            ],
          ),
          const SizedBox(height: 24),
          // Status timeline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildStatusItem(
                  icon: Icons.check_circle,
                  title:
                      transaction.isPositive
                          ? 'Request Received'
                          : 'Request Sent',
                  description: transaction.statusDescription,
                  isCompleted: true,
                  isLast: false,
                ),
                _buildStatusItem(
                  icon: Icons.check_circle,
                  title:
                      transaction.isPositive
                          ? 'Received on ${transaction.network}'
                          : 'Sent on ${transaction.network}',
                  isCompleted: true,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.person_rounded,
                  label: transaction.isPositive ? 'From' : 'To',
                  value: transaction.fromTo,
                  showCopy: true,
                ),
                // const SizedBox(height: 16),
                // _buildDetailRow(
                //   icon: Icons.receipt_rounded,
                //   label: 'Blockchain Fees',
                //   value: transaction.blockchainFees,
                // ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.language_rounded,
                  label: 'Network',
                  value: transaction.network,
                  showNetworkIcon: true,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.calendar_month_rounded,
                  label: 'Date',
                  value: transaction.date,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // View on block explorer button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(transaction.url))) {
                    launchUrl(Uri.parse(transaction.url));
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'View On Block Explorer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.open_in_new, size: 14, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    String? description,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              color: isCompleted ? const Color(0xFF26A17B) : Colors.grey,
              size: 24,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool showCopy = false,
    bool showNetworkIcon = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        if (showNetworkIcon) ...[
          AppSvg.icEth(size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          showCopy ? _formatAddress(value) : value,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        if (showCopy) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Fluttertoast.showToast(
                msg: "Copied to clipboard",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Clipboard.setData(ClipboardData(text: value));
            },
            child: Icon(Icons.copy_rounded, size: 16, color: Colors.black),
          ),
        ],
      ],
    );
  }

  _formatAddress(String sentTo) {
    return '${sentTo.substring(0, 8)}...${sentTo.substring(sentTo.length - 6)}';
  }
}
