import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:ankoot_new/theme/app_theme.dart';
import 'package:ankoot_new/widgets/evetn_screen.dart';
import 'package:get/get.dart';

import '../api/services/fcm_service.dart';
import '../controller/CRUD_controller.dart';
import '../controller/food_distribution_controller.dart';
import '../helper/toast/toast_helper.dart';
import '../models/evet_items.dart';

class MainContent extends StatefulWidget {
  final Pradesh selectedPradesh;
  final Function() onNotifyPressed;
  final Function() onUpdateEvent;

  MainContent({
    super.key,
    required this.selectedPradesh,
    required this.onNotifyPressed,
    required this.onUpdateEvent,
  });

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {

  final FoodDistributionController pradeshController = Get.put(FoodDistributionController());


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
    if (widget.selectedPradesh == null || widget.selectedPradesh!.pradeshId == 0) {
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
              child: EventScreen(key: UniqueKey(),), // Placeholder
            ),
          ),
        ],
      ),

      // ✅ Floating button in bottom right corner
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final confirmed = await _showSendToPradeshDialog(context);
          if (confirmed == true) {
            try {
              final pradeshId = widget.selectedPradesh.pradeshId.toString();
              final eventId = widget.selectedPradesh.events.first.eventId.toString();

              print("➡️ Sending to pradeshId: $pradeshId, eventId: $eventId");

              // ✅ Call API
              final success = await PradeshController.assignItemToPradesh(
                pradeshId: pradeshId,
                eventId: eventId,
              );

              if (success) {
                showToast(
                  context: context,
                  title: "Success",
                  type: ToastType.success,
                  message: "✅ Sent to pradesh successfully!",
                );
              } else {
                showToast(
                  context: context,
                  title: "Error",
                  type: ToastType.error,
                  message: "❌ Failed to send to pradesh",
                );
              }
            } catch (e) {
              print("❌ Error assigning to pradesh: $e");
              showToast(
                context: context,
                title: "Error",
                type: ToastType.error,
                message: "⚠️ Something went wrong",
              );
            }
          } else {
            print("❌ Cancelled by user");
          }
          final NotificationService notificationService = Get.find();
          bool success = await notificationService.notifyPradesh(
            pradeshId: pradeshController.selectedPradesh.value?.pradeshId.toString() ?? '', title: 'Assigned Annakut Items', message: 'Refer and Check all items',
          );

          if (success && pradeshController.selectedPradesh.value != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Notification sent to ${pradeshController.selectedPradesh.value?.pradeshEngName}',
                ),
                backgroundColor: Colors.green,
              ),
            );
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
                  widget.selectedPradesh!.pradeshGujName, // ✅ Gujarati only
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: widget.selectedPradesh!.pradeshUsers.map((user) {
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
            onPressed: widget.onNotifyPressed,
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
