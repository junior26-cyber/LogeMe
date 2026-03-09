import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/utils/app_error.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final uidCtrl = TextEditingController();
  final tokenCtrl = TextEditingController();
  bool _loadedArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;
    _loadedArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      uidCtrl.text = (args['uid'] ?? '').toString();
      tokenCtrl.text = (args['token'] ?? '').toString();
    }
  }

  Future<void> _verify() async {
    try {
      await context.read<AuthService>().verifyEmailWithToken(
            uid: uidCtrl.text.trim(),
            token: tokenCtrl.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email vérifié. Tu peux te connecter.')));
      Navigator.pushReplacementNamed(context, AppRouter.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérifier email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: uidCtrl, decoration: const InputDecoration(labelText: 'UID reçu par email')),
            const SizedBox(height: 12),
            TextField(controller: tokenCtrl, decoration: const InputDecoration(labelText: 'Token reçu par email')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _verify, child: const Text('Vérifier')),
          ],
        ),
      ),
    );
  }
}
