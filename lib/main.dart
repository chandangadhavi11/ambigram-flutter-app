// Using stub implementations
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'core/monetization/ads_stub.dart'; // Use stub implementation
import 'core/navigation/router.dart';
import 'core/services/analytics_service_stub.dart' as analytics_service;
import 'core/services/firebase_core_stub.dart';
import 'core/services/firebase_remote_config_stub.dart';
import 'features/ambigram/presentation/providers/ambigram_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'global/state/auth_notifier.dart';
import 'shared/themes/app_theme.dart';

/// Initialize services required by the app
Future<void> _initializeServices() async {
  try {
    // Initialize Remote Config using stub implementation
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 0) // Allow frequent fetches in debug mode
            : const Duration(hours: 12), // Limit fetches in production
      ));
      await remoteConfig.setDefaults({
        'min_build_version': 1,
        'default_credits': 10,
      });
      await remoteConfig.fetchAndActivate();
      debugPrint('Remote Config stub initialized with default values');
    } catch (e) {
      debugPrint('Failed to initialize Remote Config stub: $e');
    }

    // Initialize Notifications
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    debugPrint('Error initializing services: $e');
    // Crashlytics disabled
    // if (!kDebugMode) {
    //   FirebaseCrashlytics.instance.recordError(e, stackTrace);
    // }
  }
}

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase (using stub)
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase stub initialized');
  } catch (e) {
    debugPrint('Failed to initialize Firebase stub: $e');
  }

  // Initialize Mobile Ads SDK (using stub)
  await MobileAds.instance.initialize();

  // Initialize other services
  await _initializeServices();

  // Run the app
  runApp(const MyApp());
}

/// The main application widget
class MyApp extends StatefulWidget {
  /// Default constructor
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthNotifier _authNotifier = AuthNotifier();
  final SettingsProvider _settingsProvider = SettingsProvider();
  final AmbigramProvider _ambigramProvider = AmbigramProvider();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _authNotifier.initialize();
    await _settingsProvider.loadSettings();
    // Auth notifier is initialized but login is not required anymore
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>.value(value: _authNotifier),
        ChangeNotifierProvider<SettingsProvider>.value(
            value: _settingsProvider),
        ChangeNotifierProvider<AmbigramProvider>.value(
            value: _ambigramProvider),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          // Track app open event
          analytics_service.AnalyticsService.logAppOpen();

          return MaterialApp.router(
            title: 'Ambigram Generator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,
            routerConfig: buildRouter(_authNotifier),
          );
        },
      ),
    );
  }
}
