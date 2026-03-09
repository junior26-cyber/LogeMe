import 'package:flutter/material.dart';

import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/listings/home_screen.dart';
import '../../features/listings/post_listing_screen.dart';
import '../../features/notifications/notifications_screen.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot';
  static const home = '/home';
  static const postListing = '/post-listing';
  static const notifications = '/notifications';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgot: (_) => const ForgotPasswordScreen(),
    home: (_) => const HomeScreen(),
    postListing: (_) => const PostListingScreen(),
    notifications: (_) => const NotificationsScreen(),
  };
}
