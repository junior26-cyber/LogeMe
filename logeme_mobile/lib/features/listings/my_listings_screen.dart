import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/services/listing_service.dart';
import '../../shared/widgets/listing_card.dart';
import 'listing_detail_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  Map<String, dynamic>? stats;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthService>();
    final listingService = context.read<ListingService>();
    final token = auth.accessToken;
    if (token == null) return;
    await listingService.fetchMyListings(token);
    final s = await listingService.fetchStats(token);
    if (!mounted) return;
    setState(() => stats = s);
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ListingService>();
    return Column(
      children: [
        if (stats != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Annonces: ${stats!['total_listings'] ?? 0}'),
                    Text('Vues: ${stats!['total_views'] ?? 0}'),
                    Text('Contacts: ${stats!['contacts_received'] ?? 0}'),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: service.myListings.isEmpty
              ? const Center(child: Text('Aucune annonce publiée.'))
              : ListView.builder(
                  itemCount: service.myListings.length,
                  itemBuilder: (_, i) => ListingCard(
                    listing: service.myListings[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ListingDetailScreen(listingId: service.myListings[i].id)),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
