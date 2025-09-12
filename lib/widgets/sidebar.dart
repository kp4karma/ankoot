// lib/widgets/sidebar.dart
import 'package:ankoot_new/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/user_list_tile.dart';

class Sidebar extends StatelessWidget {
  final List<UserModel> users;
  final UserModel? selectedUser;
  final Function(UserModel) onUserSelected;

  const Sidebar({
    super.key,
    required this.users,
    this.selectedUser,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          _buildUserList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(children: [Expanded(child: ReusableSearchBar(onChanged: (value){}))],),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserListTile(
            user: user,
            isSelected: selectedUser?.id == user.id,
            onTap: () => onUserSelected(user),
          );
        },
      ),
    );
  }
}