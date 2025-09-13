import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/pradesh_item_controller.dart';
import '../models/pradesh_items_data_model.dart';
import '../widgets/main_content.dart';
import '../widgets/sidebar.dart';

class ItemCollectionScreen extends StatefulWidget {
  const ItemCollectionScreen({Key? key}) : super(key: key);

  @override
  State<ItemCollectionScreen> createState() => _ItemCollectionScreenState();
}

class _ItemCollectionScreenState extends State<ItemCollectionScreen> {
  final PradeshController pradeshController = Get.put(PradeshController());
  PradeshData? _selectedPradesh;

  @override
  void initState() {
    super.initState();
    // load default with eventId = 1 (you can pass dynamically)
    pradeshController.fetchPradeshItems(1);
  }

  void _onPradeshSelected(PradeshData pradesh) {
    setState(() {
      _selectedPradesh = pradesh;
    });
  }

  void _onNotifyPressed() {
    if (_selectedPradesh == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text('Notification sent to ${_selectedPradesh?.pradeshEngName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Sidebar(
              onPradeshSelected: _onPradeshSelected,
              selectedPradesh: _selectedPradesh, // <-- pass selected
            ),

          ),
        ),
        Expanded(
          child: MainContent(
            selectedPradesh: _selectedPradesh,
            onNotifyPressed: _onNotifyPressed,
          ),
        ),
      ],
    );
  }
}
