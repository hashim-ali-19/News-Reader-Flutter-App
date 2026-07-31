import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/article_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/root_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const NewsReaderApp());
}

class NewsReaderApp extends StatelessWidget {
  const NewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();

    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider(create: (_) => ThemeProvider(storageService)),
        ChangeNotifierProvider(create: (_) => BookmarkProvider(storageService)),
        ChangeNotifierProvider(
          create: (_) => ArticleProvider(storageService: storageService),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Loop — News Reader',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: const RootScreen(),
          );
        },
      ),
    );
  }
}
