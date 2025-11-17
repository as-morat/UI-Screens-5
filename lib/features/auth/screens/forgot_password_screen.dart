import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_firebase/features/auth/auth_controller.dart';
import 'package:learn_firebase/widgets/alert_box.dart';
import 'package:learn_firebase/widgets/custom_snackbar.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();

  Future<void> _sendLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar(context, "Please enter your email");
      return;
    }

    final auth = ref.read(authControllerProvider);

    setState(() {
      isLoading = true;
    });

    try {
      await auth.resetPassword(email);
      showAlert(
        context,
        message: "Password reset link sent to your email account",
      );
    } catch (e) {
      showAlert(
        context,
        message: "Failed to send reset link. Try again.",
        success: false,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          emailController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: size.height * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/reset.png",
                  color: theme.colorScheme.primary.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter email",
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: theme.colorScheme.primary,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.85),
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          "Send Link",
                          style: GoogleFonts.playfair(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
