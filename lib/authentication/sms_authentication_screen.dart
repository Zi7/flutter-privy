import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../privy_manager.dart';

class SmsAuthenticationScreen extends StatefulWidget {
  const SmsAuthenticationScreen({super.key});

  @override
  SmsAuthenticationScreenState createState() => SmsAuthenticationScreenState();
}

class SmsAuthenticationScreenState extends State<SmsAuthenticationScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool codeSent = false;
  String? errorMessage;
  bool isLoading = false;

  void _handleBackNavigation() {
    Navigator.of(context).pop();
  }

  void showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> sendCode() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      showMessage("Please enter your phone number", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await privyManager.privy.sms.sendCode(phone);

      result.fold(
        onSuccess: (_) {
          setState(() {
            codeSent = true;
            errorMessage = null;
            isLoading = false;
          });
          showMessage("Code sent successfully to $phone");
        },
        onFailure: (error) {
          setState(() {
            errorMessage = error.message;
            codeSent = false;
            isLoading = false;
          });
          showMessage("Error sending code: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      showMessage("Unexpected error: $e", isError: true);
    }
  }

  Future<void> performLogin() async {
    String code = codeController.text.trim();
    if (code.isEmpty) {
      showMessage("Please enter the verification code", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await privyManager.privy.sms.loginWithCode(
        code: code,
        phoneNumber: phoneController.text.trim(),
      );

      result.fold(
        onSuccess: (user) {
          setState(() {
            isLoading = false;
          });
          showMessage("Authentication successful!");
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            );
          }
        },
        onFailure: (error) {
          setState(() {
            errorMessage = error.message;
            isLoading = false;
          });
          showMessage("Login error: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      showMessage("Unexpected error: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SMS Authentication'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackNavigation(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'SMS Authentication',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),

                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    hintText: "+1 234 567 8900",
                    border: const OutlineInputBorder(),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: isLoading ? null : sendCode,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      isLoading && !codeSent
                          ? "Sending..."
                          : "Send Verification Code",
                    ),
                  ),
                ),

                if (codeSent) ...[
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 30),

                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Verification Code",
                      border: const OutlineInputBorder(),
                      labelStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: isLoading ? null : performLogin,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        isLoading ? "Verifying..." : "Verify & Login",
                      ),
                    ),
                  ),
                ],

                if (errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    errorMessage!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
