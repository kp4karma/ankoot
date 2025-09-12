
import 'package:ankoot_new/models/user_model.dart';
import 'package:ankoot_new/services.dart';
import 'package:ankoot_new/widgets/main_content.dart';
import 'package:ankoot_new/widgets/sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String _currentPage = 'User Management';
  UserModel? _selectedUser;
  List<UserModel> _users = [];
  List<DeliveryListModel> _deliveryLists = [];
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _users = _dataService.getUsers();
      if (_users.isNotEmpty) {
        _selectedUser = _users.first;
        _deliveryLists = _dataService.getDeliveryListsForUser(
          _selectedUser!.id,
        );
      }
    });
  }

  void _onNavigationChanged(String page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onUserSelected(UserModel user) {
    setState(() {
      _selectedUser = user;
      _deliveryLists = _dataService.getDeliveryListsForUser(user.id);
    });
  }

  void _onNotifyPressed() {
    // Handle notify user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification sent to ${_selectedUser?.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16,bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Sidebar(
              users: _users,
              selectedUser: _selectedUser,
              onUserSelected: _onUserSelected,
            ),
          ),
        ),
        MainContent(
          selectedUser: _selectedUser,
          deliveryLists: _deliveryLists,

          onNotifyPressed: _onNotifyPressed,
        ),
      ],
    );
    ;
  }
}
