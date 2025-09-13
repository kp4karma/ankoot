import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/pradesh_item_controller.dart';
import '../models/pradesh_items_data_model.dart';
import '../widgets/main_content.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PradeshController pradeshController = Get.put(PradeshController());
  String _currentPage = 'Pradesh Management';
  PradeshData? _selectedPradesh;

  @override
  void initState() {
    super.initState();
    pradeshController.fetchPradeshItems(1);
  }

  void _onNavigationChanged(String page) {
    setState(() {
      _currentPage = page;
    });
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
