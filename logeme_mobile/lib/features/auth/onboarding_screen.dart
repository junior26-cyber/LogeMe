import 'package:flutter/material.dart';

import '../../core/routes/app_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final slides = [
      'Trouve ton logement rapidement à Lomé',
      'Contact direct propriétaire ou agence',
      'Plateforme fiable pour Togo et Afrique de l\'Ouest',
    ];

    return Scaffold(
      body: PageView.builder(
        itemCount: slides.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(slides[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 32),
              if (i == slides.length - 1)
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                  child: const Text('Commencer'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
