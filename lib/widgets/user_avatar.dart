// lib/widgets/user_avatar.dart
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: avatarUrl != null
          ? ClipOval(
        child: Image.network(
          avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildInitials();
          },
        ),
      )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .take(2)
        .join();

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}




