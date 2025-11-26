import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';

class UserProfileWidget extends StatelessWidget {
  final PrivyUser user;

  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("User Profile", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.perm_identity, size: 20, color: Colors.black54),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User ID",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      user.id,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
