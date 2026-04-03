import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant': return Icons.restaurant_rounded;
      case 'directions_car': return Icons.directions_car_rounded;
      case 'shopping_bag': return Icons.shopping_bag_rounded;
      case 'sports_esports': return Icons.sports_esports_rounded;
      case 'home': return Icons.home_rounded;
      case 'payments': return Icons.payments_rounded;
      case 'redeem': return Icons.redeem_rounded;
      case 'wallet': return Icons.account_balance_wallet_rounded;
      case 'account_balance': return Icons.account_balance_rounded;
      case 'savings': return Icons.savings_rounded;
      case 'work': return Icons.work_rounded;
      case 'school': return Icons.school_rounded;
      case 'health': return Icons.medical_services_rounded;
      default: return Icons.category_rounded;
    }
  }
}
