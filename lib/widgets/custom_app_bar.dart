// lib/widgets/custom_app_bar.dart
import 'package:ankoot_new/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final Function(String) onNavigationChanged;

  const CustomAppBar({
    super.key,
    required this.currentPage,
    required this.onNavigationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: Row(
        children: [
          const Text(
            'Ankoot',
            style: TextStyle(
              color: AppTheme.primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 32),
          _buildNavigationButtons(),
        ],
      ),

      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildNavigationButtons() {
    final navItems = [
      'Assign Item',
      'Item Collection',
      'Event Item',
      'Events',
    ];

    return Row(
      children: navItems.map((item) {
        final isSelected = item == currentPage;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextButton(
            onPressed: () => onNavigationChanged(item),
            style: TextButton.styleFrom(
              foregroundColor: isSelected ? AppTheme.primaryColors : Colors.grey[700],
              backgroundColor: isSelected ? AppTheme.primaryColors.withOpacity(0.1) : null,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}