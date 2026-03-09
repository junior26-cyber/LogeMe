import 'package:flutter/material.dart';

import '../models/listing_model.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onTap;

  const ListingCard({super.key, required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(listing.title),
        subtitle: Text('${listing.neighborhood} • ${listing.city}'),
        trailing: Text('${listing.price} FCFA'),
      ),
    );
  }
}
