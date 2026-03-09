import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../shared/services/auth_service.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import 'listings_screen.dart';
import 'my_listings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final role = auth.currentUser?.role ?? 'tenant';
    final isTenant = role == 'tenant';

    final pages = [
      const ListingsScreen(),
      const ListingsScreen(),
      isTenant ? const FavoritesScreen() : const MyListingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LogeMe'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.notifications),
            icon: const Icon(Icons.notifications_none),
          )
        ],
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Accueil'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
          BottomNavigationBarItem(
            icon: Icon(isTenant ? Icons.favorite_outline : Icons.list_alt_outlined),
            label: isTenant ? 'Favoris' : 'Mes annonces',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
      floatingActionButton: isTenant
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, AppRouter.postListing),
              icon: const Icon(Icons.add),
              label: const Text('Publier'),
            ),
    );
  }
}
