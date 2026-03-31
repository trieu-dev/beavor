import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const LuminousLedgerApp());
}

class LuminousLedgerApp extends StatelessWidget {
  const LuminousLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Luminous Ledger',
      translations: AppTranslations(),
      locale: Get.deviceLocale, // Get device locale
      fallbackLocale: const Locale('en', 'US'), // English as fallback
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
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
