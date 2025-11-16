import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_firebase/features/auth/auth_controller.dart';
import 'package:learn_firebase/features/auth/screens/signup_screen.dart';
import '../../../widgets/custom_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    final auth = ref.read(authControllerProvider);

    try {
      await auth.login(email, password);
      ScaffoldMessenger.of(context).clearSnackBars();
      showCustomSnackBar(context, 'Log in successful');
    } on FirebaseAuthException catch (e) {
      final messages = {
        'wrong-password': 'Wrong password!',
        'user-not-found': 'No user found with this email',
      };
      ScaffoldMessenger.of(context).clearSnackBars();
      showCustomSnackBar(
        context,
        messages[e.code] ?? e.message ?? 'Authentication failed!',
      );
    } catch (_) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showCustomSnackBar(context, 'Unexpected error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.1),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 50),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Enter email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Please enter email';
                              final regex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+");
                              if (!regex.hasMatch(value.trim())) return 'Please enter a valid email';
                              return null;
                            },
                            onSaved: (value) => email = value?.trim() ?? "",
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Enter password",
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            onSaved: (value) => password = value?.trim() ?? "",
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Forgot password?"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                                  : Text(
                                "Sign In",
                                style: GoogleFonts.playfair(fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text("or", style: TextStyle(color: theme.colorScheme.primary)),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Image.asset("assets/images/google.png", height: 24, width: 24),
                              label: const Text("Sign In with Google"),
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.grey[600]),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.5,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
