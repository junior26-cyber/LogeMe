import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/utils/app_error.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> _login() async {
    try {
      await context.read<AuthService>().login(emailCtrl.text.trim(), passCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  Future<void> _resendVerification() async {
    try {
      await context.read<AuthService>().requestEmailVerification(emailCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Si le compte existe, un email de vérification a été envoyé.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text('Se connecter')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.forgot),
              child: const Text('Mot de passe oublié ?'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.register),
              child: const Text('Créer un compte'),
            ),
            TextButton(
              onPressed: _resendVerification,
              child: const Text('Renvoyer email de vérification'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.verifyEmail),
              child: const Text('J’ai déjà UID + token'),
            ),
          ],
        ),
      ),
    );
  }
}
