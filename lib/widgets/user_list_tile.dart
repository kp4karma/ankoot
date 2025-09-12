// lib/widgets/user_list_tile.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'user_avatar.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final bool isSelected;
  final VoidCallback? onTap;

  const UserListTile({
    super.key,
    required this.user,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border(
          left: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 4,
          ),
        )
            : null,
      ),
      child: ListTile(
        leading: UserAvatar(
          name: user.name,
          avatarUrl: user.avatarUrl,
          size: 40,
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}