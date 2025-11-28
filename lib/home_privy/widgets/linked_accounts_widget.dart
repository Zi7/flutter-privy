import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';

class LinkedAccountsWidget extends StatelessWidget {
  final PrivyUser user;
  final VoidCallback? onAccountLinked;

  const LinkedAccountsWidget({
    super.key,
    required this.user,
    this.onAccountLinked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Linked Accounts", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        if (user.linkedAccounts.isEmpty)
          const Text("No linked accounts", style: TextStyle(color: Colors.grey))
        else
          ...user.linkedAccounts.map(
            (account) => _buildAccountTile(account, context),
          ),
      ],
    );
  }

  Widget _buildAccountTile(LinkedAccounts account, BuildContext context) {
    if (account is EmailAccount) {
      return ListTile(
        leading: const Icon(Icons.email),
        title: const Text("Email Account"),
        subtitle: Text(account.emailAddress),
        dense: true,
      );
    } else if (account is PhoneNumberAccount) {
      return ListTile(
        leading: const Icon(Icons.phone),
        title: const Text("Phone Number"),
        subtitle: Text(account.phoneNumber),
        dense: true,
      );
    }
    return const SizedBox.shrink();
  }
}
