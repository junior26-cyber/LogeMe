import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../core/routes/app_router.dart';
import '../navigation/app_navigator.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    _sub = _appLinks.uriLinkStream.listen(_handleUri);
  }

  void dispose() {
    _sub?.cancel();
  }

  void _handleUri(Uri uri) {
    final route = uri.path;
    final uid = uri.queryParameters['uid'];
    final token = uri.queryParameters['token'];
    if (uid == null || token == null) return;

    final context = appNavigatorKey.currentContext;
    if (context == null) return;

    if (route.contains('verify-email')) {
      Navigator.of(context).pushNamed(
        AppRouter.verifyEmail,
        arguments: {'uid': uid, 'token': token},
      );
    } else if (route.contains('reset-password')) {
      Navigator.of(context).pushNamed(
        AppRouter.resetConfirm,
        arguments: {'uid': uid, 'token': token},
      );
    }
  }
}
