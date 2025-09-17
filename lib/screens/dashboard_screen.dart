import 'package:ankoot_new/api/services/fcm_service.dart';
import 'package:ankoot_new/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/food_distribution_controller.dart';
import '../controller/pradesh_item_controller.dart';
import '../models/evet_items.dart';
import '../widgets/main_content.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FoodDistributionController pradeshController = Get.put(FoodDistributionController(),tag:'default',permanent: false);

  EventController eventController = Get.find<EventController>();

  @override
  void initState() {
    pradeshController.isShowLeftQty.value = false;
    eventController.isDefaultData.value = true;
    pradeshController.loadData();
    super.initState();
  }



  void _onPradeshSelected(Pradesh pradesh) {
    setState(() {
      pradeshController.selectedPradesh.value = pradesh;
    });
  }

  void _onNotifyPressed() async {
    final TextEditingController noteController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title:  Text("Send message to ${pradeshController.selectedPradesh.value?.pradeshEngName}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: "Title of the Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 4, // multiline
                decoration: const InputDecoration(
                  labelText: "Description about Message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final NotificationService notificationService = Get.find();
                bool success = await notificationService.notifyPradesh(
                  pradeshId: "1",
                  title: noteController.text.trim(),
                  message: descriptionController.text.trim(),
                  pradeshName: "Karma",
                );

                Navigator.of(context).pop(); // close dialog

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
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Sidebar(
              onPradeshSelected: _onPradeshSelected,
              selectedPradesh: pradeshController.selectedPradesh.value, // <-- pass selected
            ),
          ),
        ),
        Expanded(
          child: MainContent(
            selectedPradesh: pradeshController.selectedPradesh.value,
            onNotifyPressed: _onNotifyPressed,
          ),
        ),
      ],
    ),);
  }
}
