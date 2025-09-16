import 'package:ankoot_new/theme/storage_helper.dart';
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

  Future<bool?> _showSendToPradeshDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: const [
              Icon(Icons.send, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text("Confirm Action"),
            ],
          ),
          content: const Text(
            "Are you sure you want to send to pradesh?",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // return false
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true); // return true
                // 🔑 Don't put SnackBar here, handle it outside
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (selectedPradesh == null || selectedPradesh!.pradeshId == 0) {
      return Container(
        color: const Color(0xFFF5F5F5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryColors,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Pradesh data...',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildPradeshHeader(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: EventScreen(), // Placeholder
            ),
          ),
        ],
      ),

      // ✅ Floating button in bottom right corner
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final confirmed = await _showSendToPradeshDialog(context);
          if (confirmed == true) {
            // Execute your API call or controller action
            print("✅ Proceed with sending to pradesh");
            print("${UserStorageHelper.getUserData()!.data!.pradeshAssignment!.pradeshId}");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sent to pradesh successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            print("❌ Cancelled by user");
          }
        },
        backgroundColor: AppTheme.primaryColors,
        icon: const Icon(Icons.reduce_capacity, color: Colors.white),
        label: const Text(
          'Send to Pradesh',
          style: TextStyle(color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
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

          // Pradesh Gujarati Name + Users
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedPradesh!.pradeshGujName, // ✅ Gujarati only
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: selectedPradesh!.pradeshUsers.map((user) {
                    return Chip(
                      avatar: const Icon(Icons.person, size: 18),
                      label: Text(
                        "${user.userName} - ${user.userMobile}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      backgroundColor: Colors.grey[100],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Notify button
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
