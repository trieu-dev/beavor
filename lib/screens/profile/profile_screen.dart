import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
      ),
      body: Center(
        child: Text(
          'profile'.tr,
          style: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
