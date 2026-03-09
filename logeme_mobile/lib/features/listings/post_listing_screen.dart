import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/services/listing_service.dart';
import '../../shared/utils/app_error.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final neighborhoodCtrl = TextEditingController();
  String type = 'apartment';
  LatLng selected = const LatLng(6.1375, 1.2123);
  final List<String> photoPaths = [];

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    setState(() {
      photoPaths
        ..clear()
        ..addAll(files.map((f) => f.path));
    });
  }

  Future<void> _submit() async {
    final auth = context.read<AuthService>();
    if (auth.accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecte-toi avant de publier.')));
      return;
    }

    try {
      await context.read<ListingService>().createListing(
            token: auth.accessToken!,
            title: titleCtrl.text.trim(),
            description: descCtrl.text.trim(),
            price: int.tryParse(priceCtrl.text) ?? 0,
            type: type,
            neighborhood: neighborhoodCtrl.text.trim(),
            lat: selected.latitude,
            lng: selected.longitude,
            photoPaths: photoPaths,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Annonce publiée.')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publier une annonce')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre')),
          const SizedBox(height: 12),
          TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          const SizedBox(height: 12),
          TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Prix FCFA'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(labelText: 'Type de logement'),
            items: const [
              DropdownMenuItem(value: 'studio', child: Text('Studio')),
              DropdownMenuItem(value: 'apartment', child: Text('Appartement')),
              DropdownMenuItem(value: 'room', child: Text('Chambre')),
              DropdownMenuItem(value: 'villa', child: Text('Villa')),
              DropdownMenuItem(value: 'land', child: Text('Terrain')),
            ],
            onChanged: (value) => setState(() => type = value ?? 'apartment'),
          ),
          const SizedBox(height: 12),
          TextField(controller: neighborhoodCtrl, decoration: const InputDecoration(labelText: 'Quartier')),
          const SizedBox(height: 12),
          const Text('Choisir position GPS (tap sur la carte):'),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: selected,
                initialZoom: 13,
                onTap: (_, point) => setState(() => selected = point),
              ),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                MarkerLayer(markers: [Marker(point: selected, child: const Icon(Icons.location_pin, size: 42))]),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: _pickPhotos, icon: const Icon(Icons.photo_library), label: const Text('Ajouter des photos')),
          if (photoPaths.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text('${photoPaths.length} photo(s) sélectionnée(s)')),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Publier')),
        ],
      ),
    );
  }
}
