import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Center(
        child: Text(
          'Calendar View Placeholder',
          style: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
