import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final auth = context.read<AuthService>();
      if (auth.isLoggedIn) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('LogeMe', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
