import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get_storage/get_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/i18n/app_translations.dart';
import 'core/services/supabase_service.dart';
import 'screens/login/login_screen.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  await SupabaseService().init(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Initialize AuthController
  Get.put(AuthController());

  runApp(const LuminousLedgerApp());
}

class LuminousLedgerApp extends StatelessWidget {
  const LuminousLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Beavor',
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
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
