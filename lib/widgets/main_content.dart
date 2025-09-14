import 'package:flutter/material.dart';
import 'package:ankoot_new/theme/app_theme.dart';
import 'package:ankoot_new/widgets/evetn_screen.dart';

import '../models/evet_items.dart';

class MainContent extends StatelessWidget {
  final Pradesh selectedPradesh;
  final Function() onNotifyPressed;


   MainContent({
    super.key,
    required this.selectedPradesh,
    required this.onNotifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedPradesh == null) {
      return Center(
        child: Text(
          'Select a Pradesh to view its items',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.zero,
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildPradeshHeader(context),
          ),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: EventScreen(), // Placeholder
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPradeshHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon instead of UserAvatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColors.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_tree,
              color: AppTheme.primaryColors,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedPradesh!.pradeshEngName ?? 'Unknown Pradesh',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  "${selectedPradesh!.pradeshGujName.toString()}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed: onNotifyPressed,
            icon: const Icon(Icons.notifications, size: 16),
            label: const Text('Notify'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
