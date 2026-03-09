import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/utils/app_error.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String role = 'tenant';
  String? idDocumentPath;

  Future<void> _pickIdDocument() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => idDocumentPath = file.path);
  }

  Future<void> _register() async {
    try {
      if ((role == 'owner' || role == 'agency') && (idDocumentPath == null || idDocumentPath!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pièce d’identité obligatoire pour Propriétaire/Agence.')),
        );
        return;
      }

      await context.read<AuthService>().register(
            fullName: nameCtrl.text.trim(),
            email: emailCtrl.text.trim(),
            phone: phoneCtrl.text.trim(),
            password: passCtrl.text.trim(),
            role: role,
            idDocumentPath: idDocumentPath,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte créé. Vérifie ton email via le lien reçu.')),
      );
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final requireDoc = role == 'owner' || role == 'agency';
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom complet')),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Téléphone')),
            const SizedBox(height: 12),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Rôle'),
              items: const [
                DropdownMenuItem(value: 'tenant', child: Text('Locataire')),
                DropdownMenuItem(value: 'owner', child: Text('Propriétaire')),
                DropdownMenuItem(value: 'agency', child: Text('Agence')),
              ],
              onChanged: (value) => setState(() => role = value ?? 'tenant'),
            ),
            if (requireDoc) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickIdDocument,
                icon: const Icon(Icons.badge_outlined),
                label: const Text('Ajouter pièce d’identité'),
              ),
              if (idDocumentPath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('Document sélectionné', style: Theme.of(context).textTheme.bodySmall),
                ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _register, child: const Text('Créer le compte')),
          ],
        ),
      ),
    );
  }
}
