import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/admin_theme.dart';
import 'core/widgets/admin_shell.dart';
import 'core/widgets/loading_state_widget.dart';
import 'providers/admin_auth_provider.dart';
import 'providers/admin_navigation_provider.dart';
import 'providers/books_provider.dart';
import 'providers/chapters_provider.dart';
import 'providers/verses_provider.dart';
import 'providers/daily_readings_provider.dart';
import 'providers/media_provider.dart';
import 'providers/users_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/settings_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/access_denied_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SanatanScrollAdminApp());
}

class SanatanScrollAdminApp extends StatelessWidget {
  const SanatanScrollAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminNavigationProvider()),
        ChangeNotifierProvider(create: (_) => BooksProvider()),
        ChangeNotifierProvider(create: (_) => ChaptersProvider()),
        ChangeNotifierProvider(create: (_) => VersesProvider()),
        ChangeNotifierProvider(create: (_) => DailyReadingsProvider()),
        ChangeNotifierProvider(create: (_) => MediaProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Sanatan Scroll — Production Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.lightTheme,
        home: const AuthGuardWrapper(),
      ),
    );
  }
}

class AuthGuardWrapper extends StatelessWidget {
  const AuthGuardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AdminAuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: LoadingStateWidget(message: 'Verifying Admin Credentials & Firebase Options...'),
      );
    }

    final user = authProvider.user;

    if (user == null) {
      return const LoginScreen();
    }

    if (!authProvider.isAdmin) {
      return const AccessDeniedScreen();
    }

    return const AdminShell();
  }
}
