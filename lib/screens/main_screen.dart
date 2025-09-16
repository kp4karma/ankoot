// lib/screens/dashboard_screen.dart
import 'package:ankoot_new/controller/event_controller.dart';
import 'package:ankoot_new/screens/dashboard_screen.dart';
import 'package:ankoot_new/screens/item_collection_screen.dart';
import 'package:ankoot_new/screens/pradesh_item_screen.dart';
import 'package:flutter/material.dart';


import '../widgets/custom_app_bar.dart';
import '../widgets/events_tabbar_screen.dart';
import 'item_pradesh_screen.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentPage = 'Assign Item';

  EventController eventController = Get.put(EventController());
  void _onNavigationChanged(String page) {
    setState(() {
      _currentPage = page;
    });
    print(page);
  }

  Widget getTabScreen() {
    eventController.isDefaultData.value =false;
    switch (_currentPage) {
      case "Assign Item":
        eventController.isDefaultData.value =true;
        return DashboardScreen();
      case "Item Collection":
        return ItemCollectionScreen();
      case "Pradesh wise Item":
        return SweetItemsScreen();
      case "Events":
        return EventsScreen();
      case "Item wise Pradesh":
        return ItemsPradeshScreen();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        currentPage: _currentPage,
        onNavigationChanged: _onNavigationChanged,
      ),
      body: getTabScreen(),
    );
  }
}
