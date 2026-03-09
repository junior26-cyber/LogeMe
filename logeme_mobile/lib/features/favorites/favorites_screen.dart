import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/services/favorite_service.dart';
import '../../shared/widgets/listing_card.dart';
import '../listings/listing_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_loadFavorites);
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;
    final token = context.read<AuthService>().accessToken;
    if (token != null) {
      await context.read<FavoriteService>().fetchFavorites(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = context.watch<AuthService>().accessToken;
    final service = context.watch<FavoriteService>();

    if (token == null) {
      return const Center(child: Text('Connecte-toi pour voir tes favoris.'));
    }

    if (service.listings.isEmpty) {
      return const Center(child: Text('Aucun favori pour le moment.'));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FavoriteService>().fetchFavorites(token),
      child: ListView.builder(
        itemCount: service.listings.length,
        itemBuilder: (_, i) => ListingCard(
          listing: service.listings[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ListingDetailScreen(listingId: service.listings[i].id)),
          ),
        ),
      ),
    );
  }
}
