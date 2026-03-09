import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/models/listing_model.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/favorite_service.dart';
import '../../shared/services/listing_service.dart';

class ListingDetailScreen extends StatelessWidget {
  final int listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  Future<void> _openPhone(String phone) async {
    await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _openWhatsApp(String phone, String title) async {
    final text = Uri.encodeComponent('Bonjour, je suis intéressé(e) par "$title" sur LogeMe.');
    await launchUrl(Uri.parse('https://wa.me/$phone?text=$text'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListingModel>(
      future: context.read<ListingService>().fetchDetail(listingId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final listing = snapshot.data!;
        final auth = context.read<AuthService>();
        return Scaffold(
          appBar: AppBar(title: Text(listing.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (listing.photos.isNotEmpty)
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: listing.photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(listing.photos[i], width: 280, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text('${listing.price} FCFA', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${listing.type} • ${listing.neighborhood}, ${listing.city}'),
              const SizedBox(height: 14),
              Text(listing.description),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(initialCenter: LatLng(listing.lat, listing.lng), initialZoom: 14),
                  children: [
                    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                    MarkerLayer(markers: [Marker(point: LatLng(listing.lat, listing.lng), child: const Icon(Icons.location_pin, size: 40))]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ElevatedButton.icon(onPressed: () => _openPhone(listing.ownerPhone), icon: const Icon(Icons.phone), label: const Text('Appeler'))),
                  const SizedBox(width: 10),
                  Expanded(child: ElevatedButton.icon(onPressed: () => _openWhatsApp(listing.ownerPhone, listing.title), icon: const Icon(Icons.chat), label: const Text('WhatsApp'))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: auth.accessToken == null
                          ? null
                          : () async {
                              await context.read<FavoriteService>().addFavorite(auth.accessToken!, listing.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajouté aux favoris')));
                              }
                            },
                      icon: const Icon(Icons.favorite_outline),
                      label: const Text('Favori'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: auth.accessToken == null
                          ? null
                          : () async {
                              final reasonCtrl = TextEditingController();
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Signaler cette annonce'),
                                  content: TextField(controller: reasonCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Raison')),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await context.read<FavoriteService>().reportListing(auth.accessToken!, listing.id, reasonCtrl.text.trim());
                                        if (ctx.mounted) Navigator.pop(ctx);
                                      },
                                      child: const Text('Envoyer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      icon: const Icon(Icons.flag_outlined),
                      label: const Text('Signaler'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
