import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Member data model for the list
class Member {
  final int id;
  final String name;
  final String contact; // email or phone
  final Color avatarColor;

  const Member({
    required this.id,
    required this.name,
    required this.contact,
    required this.avatarColor,
  });

  /// Extract initials from Vietnamese name (first char of last two words)
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2][0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}

// Sample data matching the Stitch mockup
  final List<Member> allMembers = const [
    Member(
      id: 1,
      name: 'Nguyễn Văn An',
      contact: 'an.nguyen@email.com',
      avatarColor: Color(0xFF818CF8),
    ),
    Member(
      id: 2,
      name: 'Trần Thị Bình',
      contact: '0912 345 678',
      avatarColor: Color(0xFF34D399),
    ),
    Member(
      id: 3,
      name: 'Lê Hoàng Cường',
      contact: 'cuong.le@email.com',
      avatarColor: Color(0xFFFB7185),
    ),
    Member(
      id: 4,
      name: 'Phạm Minh Đức',
      contact: '0987 654 321',
      avatarColor: Color(0xFFF59E0B),
    ),
    Member(
      id: 5,
      name: 'Hoàng Thị Em',
      contact: 'em.hoang@email.com',
      avatarColor: Color(0xFF06B6D4),
    ),
    Member(
      id: 6,
      name: 'Võ Đình Phúc',
      contact: '0901 234 567',
      avatarColor: Color(0xFFA78BFA),
    ),
    Member(
      id: 7,
      name: 'Đặng Ngọc Quỳnh',
      contact: 'quynh.dang@email.com',
      avatarColor: Color(0xFF2DD4BF),
    ),
    Member(
      id: 8,
      name: 'Bùi Thanh Hà',
      contact: '0978 123 456',
      avatarColor: Color(0xFFFF6B6B),
    ),
  ];

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({super.key});

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  final List<int> selectedIds = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Member> get _filteredMembers {
    if (_searchQuery.value.isEmpty) return allMembers;
    final query = _searchQuery.value.toLowerCase();
    return allMembers
        .where(
          (m) =>
              m.name.toLowerCase().contains(query) ||
              m.contact.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 8),
            _buildSearchBar(),
            const SizedBox(height: 8),
            _buildMemberCount(),
            const SizedBox(height: 4),
            Expanded(child: _buildMemberList()),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual create logic
                Get.back<List<int>>(result: selectedIds);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9489FE),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Chọn',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ).paddingAll(8.0)
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.onSurface,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerLow,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'members_title'.tr,
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          IconButton(
            onPressed: _showAddMemberDialog,
            icon: const Icon(Icons.person_add_rounded),
            color: AppColors.primary,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar (Glassmorphism) ───────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _searchQuery.value = value,
              style: GoogleFonts.inter(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'members_search_hint'.tr,
                hintStyle: GoogleFonts.inter(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Member Count ─────────────────────────────────────────────────────
  Widget _buildMemberCount() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_filteredMembers.length}',
                style: GoogleFonts.manrope(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'members_count_label'.tr,
              style: GoogleFonts.inter(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Member List ──────────────────────────────────────────────────────
  Widget _buildMemberList() {
    return Obx(() {
      final members = _filteredMembers;

      if (members.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 64,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'members_empty'.tr,
                style: GoogleFonts.inter(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: members.length,
        itemBuilder: (context, index) => _buildMemberCard(members[index]),
      );
    });
  }

  // ── Member Card (Glassmorphism) ──────────────────────────────────────
  Widget _buildMemberCard(Member member) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border(
                top: BorderSide(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.08),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                // Avatar with gradient glow
                _buildAvatar(member),
                const SizedBox(width: 16),
                // Name & Contact
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: GoogleFonts.manrope(
                          color: AppColors.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.contact,
                        style: GoogleFonts.inter(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Options icon
                IconButton(
                  onPressed: () => _showMemberOptions(member),
                  icon: const Icon(Icons.more_vert_rounded),
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainer.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Avatar with ambient glow ─────────────────────────────────────────
  Widget _buildAvatar(Member member) {
    return IconButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero)
      ),
      onPressed: () {
        setState(() {
          selectedIds.contains(member.id) ? selectedIds.remove(member.id) : selectedIds.add(member.id);
        });
      },
      icon: selectedIds.contains(member.id) ? Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF9489FE).withValues(alpha: 0.3),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFF9489FE).withValues(alpha: 0.2),
          child: Icon(Icons.check)
        ),
      ) : Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: member.avatarColor.withValues(alpha: 0.3),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: member.avatarColor.withValues(alpha: 0.2),
          child: Text(
            member.initials,
            style: GoogleFonts.manrope(
              color: member.avatarColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      )
    );
  }

  // ── FAB (Gradient) ───────────────────────────────────────────────────
  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDim.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showAddMemberDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  // ── Bottom Navigation ────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    Icons.home_rounded,
                    'nav_home'.tr,
                    isActive: false,
                  ),
                  _buildNavItem(
                    Icons.group_rounded,
                    'members_nav'.tr,
                    isActive: true,
                  ),
                  _buildNavItem(
                    Icons.analytics_rounded,
                    'members_nav_report'.tr,
                    isActive: false,
                  ),
                  _buildNavItem(
                    Icons.settings_rounded,
                    'members_nav_settings'.tr,
                    isActive: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label, {
    bool isActive = false,
  }) {
    final color =
        isActive
            ? AppColors.primary
            : AppColors.onSurfaceVariant.withValues(alpha: 0.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.12) : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Dialogs & Actions ────────────────────────────────────────────────
  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final contactController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'members_add_title'.tr,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                style: GoogleFonts.inter(color: AppColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'members_name_label'.tr,
                  labelStyle: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contactController,
                style: GoogleFonts.inter(color: AppColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'members_contact_label'.tr,
                  labelStyle: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant,
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'cancel'.tr,
                      style: GoogleFonts.inter(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add member logic with controller
                        Get.back();
                        Get.snackbar(
                          'success'.tr,
                          'members_add_success'.tr,
                          backgroundColor: AppColors.secondaryContainer,
                          colorText: AppColors.onSurface,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 16,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'members_add_button'.tr,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberOptions(Member member) {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Member info header
                Row(
                  children: [
                    _buildAvatar(member),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.contact,
                          style: GoogleFonts.inter(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildOptionTile(
                  icon: Icons.edit_rounded,
                  label: 'members_opt_edit'.tr,
                  color: AppColors.primary,
                  onTap: () => Get.back(),
                ),
                _buildOptionTile(
                  icon: Icons.call_rounded,
                  label: 'members_opt_call'.tr,
                  color: AppColors.secondary,
                  onTap: () => Get.back(),
                ),
                _buildOptionTile(
                  icon: Icons.delete_outline_rounded,
                  label: 'members_opt_remove'.tr,
                  color: AppColors.tertiary,
                  onTap: () => Get.back(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
