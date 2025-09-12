// lib/widgets/main_content.dart
import 'package:ankoot_new/theme/app_theme.dart';
import 'package:ankoot_new/widgets/evetn_screen.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/user_avatar.dart';
import '../widgets/delivery_list_card.dart';
import '../widgets/add_item_button.dart';

class MainContent extends StatelessWidget {
  final UserModel? selectedUser;
  final List<DeliveryListModel> deliveryLists;
  final Function() onNotifyPressed;

  const MainContent({
    super.key,
    this.selectedUser,
    required this.deliveryLists,
    required this.onNotifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedUser == null) {
      return const Center(
        child: Text(
          'Select a user to view their delivery lists',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(0),
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildUserHeader(context),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
                child: EventScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),

      child: Row(
        children: [
          UserAvatar(
            name: selectedUser!.name,
            avatarUrl: selectedUser!.avatarUrl,
            size: 60,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedUser!.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: AppTheme.primaryColors),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [Text("Karma Patel | +91 6352414412")],
                          ),
                        ),
                      );
                    },
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
