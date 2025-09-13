// lib/screens/dashboard_screen.dart
import 'package:ankoot_new/screens/dashboard_screen.dart';
import 'package:ankoot_new/screens/evetn_item_screen.dart';
import 'package:ankoot_new/screens/item_collection_screen.dart';
import 'package:flutter/material.dart';


import '../widgets/custom_app_bar.dart';
import '../widgets/events_tabbar_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentPage = 'Assign Item';

  void _onNavigationChanged(String page) {
    setState(() {
      _currentPage = page;
    });
    print(page);
  }

  Widget getTabScreen() {
    switch (_currentPage) {
      case "Assign Item":
        return DashboardScreen();
      case "Item Collection":
        return ItemCollectionScreen();
      case "Event Item":
        return SweetItemsScreen();
      case "Events":
        return EventsScreen();
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
