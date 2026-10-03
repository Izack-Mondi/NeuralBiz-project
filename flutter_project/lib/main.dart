import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/api_client.dart';
import 'data/auth_controller.dart';
import 'data/connection_request_repository.dart';
import 'data/feed_controller.dart';
import 'data/local_storage.dart';
import 'data/product_repository.dart';
import 'data/sale_request_repository.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('listings');
  await Hive.openBox('connection_requests');

  final apiClient = ApiClient();
  final feedController = FeedController(apiClient, useMockData: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProductRepository()),
        ChangeNotifierProvider(create: (_) => SaleRequestRepository()),
        ChangeNotifierProvider(create: (_) => ConnectionRequestRepository()),
        ChangeNotifierProvider(create: (_) => LocalStorage()),
        ChangeNotifierProvider.value(value: feedController),
        Provider<ApiClient>(create: (_) => apiClient),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
