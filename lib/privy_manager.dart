import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';

class PrivyManager {
  PrivyManager._();

  static final PrivyManager _instance = PrivyManager._();

  factory PrivyManager() => _instance;

  Privy? _privySdk;

  Privy get privy {
    if (_instance._privySdk == null) {
      throw Exception(
        'PrivyManager has not been initialized. Call initialize() first.',
      );
    }
    return _instance._privySdk!;
  }

  bool get isInitialized => _privySdk != null;

  void initializePrivy() {
    try {
      final privyConfig = PrivyConfig(
        appId: 'cmi7com71052ql40c0opu7tff',
        appClientId: 'client-WY6TBjLk2Q8xzZhQNR5fdQ3vCM56GNPtumEJPKcCj16VP',
        logLevel: PrivyLogLevel.debug,
      );

      _privySdk = Privy.init(config: privyConfig);
      debugPrint('Privy SDK initialized');
    } catch (e, stack) {
      debugPrint('Privy initialization failed: $e\n$stack');
      rethrow;
    }
  }
}

PrivyManager get privyManager => PrivyManager();
