import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/models/listing_model.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/listing_service.dart';
import '../../shared/utils/app_error.dart';

class EditListingScreen extends StatefulWidget {
  final ListingModel listing;

  const EditListingScreen({super.key, required this.listing});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late final TextEditingController titleCtrl;
  late final TextEditingController descCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController neighborhoodCtrl;
  late final TextEditingController latCtrl;
  late final TextEditingController lngCtrl;
  late String type;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.listing.title);
    descCtrl = TextEditingController(text: widget.listing.description);
    priceCtrl = TextEditingController(text: widget.listing.price.toString());
    neighborhoodCtrl = TextEditingController(text: widget.listing.neighborhood);
    latCtrl = TextEditingController(text: widget.listing.lat.toString());
    lngCtrl = TextEditingController(text: widget.listing.lng.toString());
    type = widget.listing.type;
  }

  Future<void> _save() async {
    final token = context.read<AuthService>().accessToken;
    if (token == null) return;
    try {
      await context.read<ListingService>().updateListing(
            token: token,
            id: widget.listing.id,
            title: titleCtrl.text.trim(),
            description: descCtrl.text.trim(),
            price: int.tryParse(priceCtrl.text.trim()) ?? 0,
            type: type,
            neighborhood: neighborhoodCtrl.text.trim(),
            lat: double.tryParse(latCtrl.text.trim()) ?? widget.listing.lat,
            lng: double.tryParse(lngCtrl.text.trim()) ?? widget.listing.lng,
          );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier l’annonce')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre')),
          const SizedBox(height: 10),
          TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 10),
          TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Prix FCFA')),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'studio', child: Text('Studio')),
              DropdownMenuItem(value: 'apartment', child: Text('Appartement')),
              DropdownMenuItem(value: 'room', child: Text('Chambre')),
              DropdownMenuItem(value: 'villa', child: Text('Villa')),
              DropdownMenuItem(value: 'land', child: Text('Terrain')),
            ],
            onChanged: (v) => setState(() => type = v ?? type),
          ),
          const SizedBox(height: 10),
          TextField(controller: neighborhoodCtrl, decoration: const InputDecoration(labelText: 'Quartier')),
          const SizedBox(height: 10),
          TextField(controller: latCtrl, decoration: const InputDecoration(labelText: 'Latitude')),
          const SizedBox(height: 10),
          TextField(controller: lngCtrl, decoration: const InputDecoration(labelText: 'Longitude')),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _save, child: const Text('Enregistrer')),
        ],
      ),
    );
  }
}
