import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/navigation/app_navigator.dart';
import 'shared/services/auth_service.dart';
import 'shared/services/deep_link_service.dart';
import 'shared/services/favorite_service.dart';
import 'shared/services/listing_service.dart';

void main() {
  runApp(const LogeMeApp());
}

class LogeMeApp extends StatefulWidget {
  const LogeMeApp({super.key});

  @override
  State<LogeMeApp> createState() => _LogeMeAppState();
}

class _LogeMeAppState extends State<LogeMeApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    _deepLinkService.init();
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..loadSession()),
        ChangeNotifierProvider(create: (_) => ListingService()),
        ChangeNotifierProvider(create: (_) => FavoriteService()),
      ],
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        title: 'LogeMe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
