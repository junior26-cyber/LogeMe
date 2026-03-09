import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/services/listing_service.dart';
import '../../shared/widgets/listing_card.dart';
import 'listing_detail_screen.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final neighborhoodCtrl = TextEditingController();
  final minCtrl = TextEditingController();
  final maxCtrl = TextEditingController();
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      context.read<ListingService>().fetchListings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ListingService>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(controller: neighborhoodCtrl, decoration: const InputDecoration(labelText: 'Quartier')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: minCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Prix min'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: maxCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Prix max'))),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.read<ListingService>().fetchListings(
                        neighborhood: neighborhoodCtrl.text.trim(),
                        priceMin: int.tryParse(minCtrl.text),
                        priceMax: int.tryParse(maxCtrl.text),
                      ),
                  icon: const Icon(Icons.search),
                  label: const Text('Appliquer les filtres'),
                ),
              ),
            ],
          ),
        ),
        if (service.isLoading) const LinearProgressIndicator(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<ListingService>().fetchListings(),
            child: ListView.builder(
              itemCount: service.listings.length,
              itemBuilder: (_, i) => ListingCard(
                listing: service.listings[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListingDetailScreen(listingId: service.listings[i].id),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
