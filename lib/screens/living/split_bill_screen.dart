import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../members/members_list_screen.dart';

class SplitBillScreen extends StatelessWidget {
  const SplitBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: AppBar(
        title: const Text('Chia hóa đơn nhóm'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildBillGroupCard(
            title: 'Tiền xe (3 xe)',
            subtitle: 'Minh Tú, Lan Anh, Hoàng Long đã trả',
            onEdit: () {
              // TODO: Implement edit logic
            },
          ),
          const SizedBox(height: 16),
          _buildMembersButton(),
          const SizedBox(height: 16),
          _buildBillGroupCard(
            title: 'Cafe (Nhóm 5 người mời)',
            subtitle: 'Bích Phương & 4 người khác tài trợ',
            onEdit: () {
              // TODO: Implement edit logic
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement create new group logic
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
                'Tạo nhóm mới',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersButton() {
    return GestureDetector(
      onTap: () => Get.to(() => const MembersListScreen()),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161C2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF9489FE).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9489FE), Color(0xFF7B66FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.people_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danh sách thành viên',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Quản lý thành viên trong nhóm',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9489FE),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillGroupCard({
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B101B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF9489FE),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white54,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
