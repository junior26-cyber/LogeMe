import 'package:flutter/material.dart';

import '../../core/routes/app_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const message = 'Plateforme simple et moderne pour trouver ou publier un logement.';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
              child: const Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }
}
