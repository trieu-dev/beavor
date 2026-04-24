import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/category_model.dart';
import '../../core/utils/icon_mapper.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen>
    with SingleTickerProviderStateMixin {
  final TransactionController controller = Get.find<TransactionController>();
  final TextEditingController _nameController = TextEditingController();

  // Available icons for selection (matching the Stitch design)
  static const List<String> _availableIcons = [
    'restaurant',
    'shopping_bag',
    'flight',
    'health',
    'sports_esports',
    'redeem',
    'directions_car',
    'home',
    'local_gas_station',
    'local_laundry_service',
    'payments',
    'school',
  ];

  // Color palette matching the Stitch design
  static const List<List<Color>> _colorGradients = [
    [Color(0xFFB6A0FF), Color(0xFF7E51FF)], // Primary purple
    [Color(0xFF68FADD), Color(0xFF006B5C)], // Teal/Secondary
    [Color(0xFFFF716C), Color(0xFFF94D4E)], // Coral/Tertiary
    [Color(0xFFFFD26C), Color(0xFFFF9E00)], // Gold
    [Color(0xFF6CAFFF), Color(0xFF0055FF)], // Blue
    [Color(0xFFDA6CFF), Color(0xFFA200FF)], // Purple
    [Color(0xFFFF8EC7), Color(0xFFD63384)], // Pink
    [Color(0xFFC1FF72), Color(0xFF6DA500)], // Lime
    [Color(0xFFFF9D6C), Color(0xFFE65100)], // Orange
    [Color(0xFF00E5FF), Color(0xFF00838F)], // Cyan
  ];

  String _selectedIcon = _availableIcons[0];
  int _selectedColorIndex = 0;
  bool _isIncome = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'add_cat_default_name'.tr;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Color get _selectedColor => _colorGradients[_selectedColorIndex][0];
  List<Color> get _selectedGradient => _colorGradients[_selectedColorIndex];

  String _generateId() {
    return const Uuid().v4();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'add_cat_error_name'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.9),
        colorText: AppColors.tertiary,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    final category = CategoryModel(
      id: _generateId(),
      name: name,
      icon: _selectedIcon,
      colorValue: _selectedColor.toARGB32(),
      isIncome: _isIncome,
    );

    controller.addCategory(category);
    Get.back();

    Get.snackbar(
      'success'.tr,
      'add_cat_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
      colorText: AppColors.onSurface,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'add_cat_title'.tr,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // Background Ambient Glow
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview Section
                  _buildSectionLabel('add_cat_preview'.tr),
                  const SizedBox(height: 12),
                  _buildPreviewCard(),
                  const SizedBox(height: 32),

                  // Name Input
                  _buildSectionLabel('add_cat_name_label'.tr),
                  const SizedBox(height: 12),
                  _buildNameInput(),
                  const SizedBox(height: 32),

                  // Type Toggle (Income/Expense)
                  _buildSectionLabel('add_cat_type_label'.tr),
                  const SizedBox(height: 12),
                  _buildTypeToggle(),
                  const SizedBox(height: 32),

                  // Icon Grid
                  _buildSectionLabel('add_cat_icon_label'.tr),
                  const SizedBox(height: 12),
                  _buildIconGrid(),
                  const SizedBox(height: 32),

                  // Color Selection
                  _buildSectionLabel('add_cat_color_label'.tr),
                  const SizedBox(height: 12),
                  _buildColorPicker(),
                ],
              ),
            ),
          ),

          // Bottom Submit Button
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Background mesh glow
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _selectedGradient[0].withValues(alpha: 0.1),
                      _selectedGradient[1].withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon circle with glow
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _selectedGradient,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedGradient[0].withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      IconMapper.getIconData(_selectedIcon),
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category name
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : 'add_cat_default_name'.tr,
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'add_cat_preview_subtitle'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.manrope(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'add_cat_name_hint'.tr,
              hintStyle: GoogleFonts.inter(
                color: AppColors.outline,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
              fillColor: Colors.transparent,
              filled: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          _buildToggleItem(
            label: 'add_tx_expense'.tr,
            isSelected: !_isIncome,
            activeColor: AppColors.tertiary,
            onTap: () => setState(() => _isIncome = false),
          ),
          _buildToggleItem(
            label: 'add_tx_income'.tr,
            isSelected: _isIncome,
            activeColor: AppColors.secondary,
            onTap: () => setState(() => _isIncome = true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: isSelected
                ? Border.all(color: activeColor.withValues(alpha: 0.3))
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                color: isSelected
                    ? activeColor
                    : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _availableIcons.length,
        itemBuilder: (context, index) {
          final iconName = _availableIcons[index];
          final isSelected = _selectedIcon == iconName;

          return GestureDetector(
            onTap: () => setState(() => _selectedIcon = iconName),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _selectedGradient,
                      )
                    : null,
                color: isSelected ? null : AppColors.surfaceContainerHighest,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              _selectedGradient[0].withValues(alpha: 0.5),
                          blurRadius: 15,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                IconMapper.getIconData(iconName),
                color: isSelected
                    ? Colors.white
                    : AppColors.onSurfaceVariant,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _colorGradients.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final isSelected = _selectedColorIndex == index;
          final gradient = _colorGradients[index];

          return GestureDetector(
            onTap: () => setState(() => _selectedColorIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                border: isSelected
                    ? Border.all(color: gradient[0], width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              // Ring offset effect for selected
              padding: isSelected ? const EdgeInsets.all(3) : null,
              child: isSelected
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        ),
                        border: Border.all(
                          color: AppColors.background,
                          width: 3,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background.withValues(alpha: 0.0),
              AppColors.background.withValues(alpha: 0.9),
              AppColors.background,
            ],
          ),
        ),
        child: GestureDetector(
          onTap: _submit,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _selectedGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: _selectedGradient[0].withValues(alpha: 0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'add_cat_submit'.tr,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
