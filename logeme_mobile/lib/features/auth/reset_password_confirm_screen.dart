import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/utils/app_error.dart';

class ResetPasswordConfirmScreen extends StatefulWidget {
  const ResetPasswordConfirmScreen({super.key});

  @override
  State<ResetPasswordConfirmScreen> createState() => _ResetPasswordConfirmScreenState();
}

class _ResetPasswordConfirmScreenState extends State<ResetPasswordConfirmScreen> {
  final uidCtrl = TextEditingController();
  final tokenCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> _submit() async {
    try {
      await context.read<AuthService>().resetPasswordConfirm(
            uid: uidCtrl.text.trim(),
            token: tokenCtrl.text.trim(),
            newPassword: passCtrl.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mot de passe réinitialisé.')));
      Navigator.pushReplacementNamed(context, AppRouter.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau mot de passe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: uidCtrl, decoration: const InputDecoration(labelText: 'UID reçu par email')),
            const SizedBox(height: 12),
            TextField(controller: tokenCtrl, decoration: const InputDecoration(labelText: 'Token reçu par email')),
            const SizedBox(height: 12),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Nouveau mot de passe'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text('Confirmer')),
          ],
        ),
      ),
    );
  }
}
