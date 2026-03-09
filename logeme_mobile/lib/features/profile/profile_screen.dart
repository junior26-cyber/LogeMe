import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user?.fullName ?? 'Utilisateur', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(user?.email ?? ''),
          Text(user?.phone ?? ''),
          Text('Rôle: ${user?.role ?? '-'}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (_) => false);
              }
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
