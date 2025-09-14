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
  final FoodDistributionController pradeshController = Get.put(FoodDistributionController());


  @override
  void initState() {
    pradeshController.isShowLeftQty.value = false;
    super.initState();
  }



  void _onPradeshSelected(Pradesh pradesh) {
    setState(() {
      pradeshController.selectedPradesh.value = pradesh;
    });
  }

  void _onNotifyPressed() {
    if (pradeshController.selectedPradesh.value == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text('Notification sent to ${pradeshController.selectedPradesh.value?.pradeshEngName}'),
        backgroundColor: Colors.green,
      ),
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
