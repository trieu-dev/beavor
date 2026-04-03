import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'core/i18n/app_translations.dart';
import 'core/services/hive_service.dart';
import 'screens/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const LuminousLedgerApp());
}

class LuminousLedgerApp extends StatelessWidget {
  const LuminousLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Luminous Ledger',
      translations: AppTranslations(),
      locale: const Locale('vi', 'VN'), // Default to Vietnamese
      fallbackLocale: const Locale('en', 'US'), // English as fallback
      // fallbackLocale: const Locale('vi', 'VN'), // Vietnamese as fallback
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('vi', 'VN'), // Vietnamese
      ],
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
