import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_title': 'Luminous Ledger',
          'net_worth': 'Net Worth',
          'income': 'Income',
          'expenses': 'Expenses',
          'history': 'History',
          'analysis': 'Analysis',
          'wallets': 'Wallets',
          'recent_activity': 'Recent Activity',
          'see_all': 'See All',
          'no_recent_transactions': 'No recent transactions.',
        },
        'vi_VN': {
          'app_title': 'Luminous Ledger',
          'net_worth': 'Tổng tài sản',
          'income': 'Thu nhập',
          'expenses': 'Chi phí',
          'history': 'Lịch sử',
          'analysis': 'Phân tích',
          'wallets': 'Ví',
          'recent_activity': 'Hoạt động gần đây',
          'see_all': 'Xem tất cả',
          'no_recent_transactions': 'Không có giao dịch nào gần đây.',
        }
      };
}
