import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/services/listing_service.dart';
import '../../shared/utils/app_error.dart';
import '../../shared/widgets/listing_card.dart';
import 'edit_listing_screen.dart';
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

  Future<void> _delete(int id) async {
    final token = context.read<AuthService>().accessToken;
    if (token == null) return;
    try {
      await context.read<ListingService>().deleteListing(token: token, id: id);
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Annonce supprimée.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(readableError(e))));
    }
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
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: service.myListings.length,
                    itemBuilder: (_, i) {
                      final item = service.myListings[i];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Supprimer'),
                                  content: const Text('Supprimer cette annonce ?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                                    ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
                                  ],
                                ),
                              ) ??
                              false;
                        },
                        onDismissed: (_) => _delete(item.id),
                        child: ListTile(
                          title: ListingCard(
                            listing: item,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ListingDetailScreen(listingId: item.id)),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              final changed = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(builder: (_) => EditListingScreen(listing: item)),
                              );
                              if (changed == true) {
                                await _loadData();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
