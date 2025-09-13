// lib/widgets/user_header/user_header.dart
import 'package:ankoot_new/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final User selectedUser;
  final VoidCallback onNotifyPressed;

  const UserHeader({
    super.key,
    required this.selectedUser,
    required this.onNotifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          UserAvatar(
            name: selectedUser.name,
            avatarUrl: selectedUser.avatarUrl,
            size: 60,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: UserInfoSection(
              user: selectedUser,
            ),
          ),
          NotifyButton(
            onPressed: onNotifyPressed,
          ),
        ],
      ),
    );
  }
}

// lib/widgets/user_header/user_info_section.dart
class UserInfoSection extends StatelessWidget {
  final User user;

  const UserInfoSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 4),
        UserContactChips(
          contacts: user.contacts, // Assuming user has contacts list
        ),
      ],
    );
  }
}

// lib/widgets/user_header/user_contact_chips.dart
class UserContactChips extends StatelessWidget {
  final List<Contact> contacts;

  const UserContactChips({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < contacts.length - 1 ? 8 : 0),
            child: ContactChip(
              contact: contacts[index],
            ),
          );
        },
      ),
    );
  }
}

// lib/widgets/user_header/contact_chip.dart
class ContactChip extends StatelessWidget {
  final Contact contact;

  const ContactChip({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.blue),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: Text(
            "${contact.name} | ${contact.phone}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

// lib/widgets/user_header/notify_button.dart
class NotifyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NotifyButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.notifications, size: 16),
      label: const Text('Notify'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black87,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// lib/models/contact.dart
class Contact {
  final String name;
  final String phone;
  final String? email;

  const Contact({
    required this.name,
    required this.phone,
    this.email,
  });
}

// lib/models/user.dart (Updated to include contacts)
class User {
  final String id;
  final String name;
  final String? avatarUrl;
  final List<Contact> contacts;

  const User({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.contacts = const [],
  });
}

