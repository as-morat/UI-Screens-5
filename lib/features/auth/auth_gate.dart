import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_firebase/features/auth/auth_providers.dart';
import 'package:learn_firebase/features/auth/screens/login_screen.dart';
import 'package:learn_firebase/features/auth/screens/verify_email_screen.dart';
import 'package:learn_firebase/screens/home_screen.dart';
import 'package:learn_firebase/widgets/custom_snackbar.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const LoginScreen();
        if (!user.emailVerified) return const VerifyEmailScreen();
        return const HomeScreen();
      },
      error: (err, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomSnackBar(context, err.toString());
        });
        return const Scaffold(body: Center(child: Text("Error loading user")));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
