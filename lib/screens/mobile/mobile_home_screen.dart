// lib/screens/mobile/mobile_home_screen.dart
import 'package:ankoot_new/widgets/prasadm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  // Sample data - replace with your actual data source
  late User currentUser;
  final GlobalKey _cardKey = GlobalKey();

  int selectedEventIndex = 0;

  // Sample events list
  final List<Event> events = [
    Event(id: '1', name: 'Diwali Ankoot - 2025', date: '01/01/2025'),
    Event(id: '2', name: 'Holi Festival - 2025', date: '15/03/2025'),
    Event(id: '3', name: 'Navratri - 2025', date: '10/10/2025'),
    Event(id: '4', name: 'Janmashtami - 2025', date: '20/08/2025'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with sample data
    currentUser = User(
      id: '1',
      name: 'Hari Sumiran',
      initials: 'HS',
      contacts: [
        Contact(name: 'Karma Patel', phone: '6352411412'),
        Contact(name: 'Raj Singh', phone: '9876543210'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobileUserHeader(user: currentUser, onContactTap: _onContactTap),

            _buildEventChipsRow(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RepaintBoundary(
                key: _cardKey,
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black.withAlpha(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Diwali Ankoot - 2025",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Text(
                                "Event Date: 01/01/2025",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text(
                                      "Sr.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      "Item Name",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text(
                                      "Qty",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Text(
                                      "Left Qty",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text(
                                      "Unit",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                primary: false,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Text(
                                            "${index+1}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 3,
                                          child: Text(
                                            "Kajukatri",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Text(
                                            "30",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ), Flexible(
                                          fit: FlexFit.tight,
                                          flex: 2,
                                          child: Text(
                                            "10",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Text(
                                            "kg",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                           
                                  Expanded(
                                    child: Text(
                                      "નોધ:- તા. 23-09-2025. સુધી માં AVD મંદિર એ મોકલી આપવું.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildActionButtons(),
            ),

            PrasadamWidget(),
            SizedBox(height: kBottomNavigationBarHeight,),
          ],
        ),
      ),
    );
  }
  Widget _buildEventChipsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedEventIndex;
            return Padding(
              padding: EdgeInsets.only(
                right: index < events.length - 1 ? 8 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEventIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepOrange
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.deepOrange.withAlpha(30),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: Text(
                      events[index].name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _shareCard,
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _notifyUser,
                icon: const Icon(Icons.notifications, size: 18),
                label: const Text('Notify'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 1,
                ),
              ),
            ), const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _notifyUser,
                icon: const Icon(Icons.history, size: 18),
                label: const Text('History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Preparing to share...'),
          ],
        ),
      ),
    );
  }



  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onContactTap(Contact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped ${contact.name}: ${contact.phone}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareCard() async {
    try {
      // Show loading
      _showLoadingDialog();

      // Wait for the next frame to ensure the widget is fully rendered
      await Future.delayed(const Duration(milliseconds: 100));

      // Now we can safely cast to RenderRepaintBoundary
      RenderRepaintBoundary boundary = _cardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/user_card_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(pngBytes);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Share the image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out ${currentUser.name}\'s contact details',
        subject: 'Contact Card - ${currentUser.name}',
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Close loading
      print("Share error: $e");
      _showErrorSnackBar('Failed to share: $e');
    }
  }

  void _notifyUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.notifications, color: Colors.deepOrange),
            const SizedBox(width: 8),
            const Text('Send Notification'),
          ],
        ),
        content: Text('Send a notification to ${currentUser.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // _showSuccessSnackBar('Notification sent to ${currentUser.name}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      title: const Text(
        "Ankoot",
        style: TextStyle(letterSpacing: 1, color: Colors.white),
      ),
      backgroundColor: Colors.deepOrange,
      elevation: 2,
    );
  }

}

// lib/widgets/mobile/mobile_user_header.dart
class MobileUserHeader extends StatelessWidget {
  final User user;
  final Function(Contact)? onContactTap;

  const MobileUserHeader({Key? key, required this.user, this.onContactTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.deepOrange.shade50,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(initials: user.initials, radius: 30),
            const SizedBox(width: 12),
            Expanded(
              child: UserInfoSection(user: user, onContactTap: onContactTap),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/widgets/mobile/user_avatar.dart
class UserAvatar extends StatelessWidget {
  final String initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;

  const UserAvatar({
    Key? key,
    required this.initials,
    this.radius = 25,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.deepOrange.shade50,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.black,
        ),
      ),
    );
  }
}

// lib/widgets/mobile/user_info_section.dart
class UserInfoSection extends StatelessWidget {
  final User user;
  final Function(Contact)? onContactTap;

  const UserInfoSection({Key? key, required this.user, this.onContactTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        if (user.contacts.isNotEmpty)
          ContactChipList(contacts: user.contacts, onContactTap: onContactTap),
      ],
    );
  }
}

// lib/widgets/mobile/contact_chip_list.dart
class ContactChipList extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact)? onContactTap;

  const ContactChipList({Key? key, required this.contacts, this.onContactTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < contacts.length - 1 ? 8 : 0,
            ),
            child: ContactChip(
              contact: contacts[index],
              onTap: onContactTap != null
                  ? () => onContactTap!(contacts[index])
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// lib/widgets/mobile/contact_chip.dart
class ContactChip extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactChip({Key? key, required this.contact, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.deepOrange.shade200),
          borderRadius: BorderRadius.circular(8),
          color: Colors.deepOrange.withAlpha(10),
        ),
        child: Center(
          child: Text(
            "${contact.name} | ${contact.phone}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String initials;
  final List<Contact> contacts;

  const User({
    required this.id,
    required this.name,
    required this.initials,
    this.contacts = const [],
  });
}

// lib/models/contact.dart
class Contact {
  final String name;
  final String phone;
  final String? email;

  const Contact({required this.name, required this.phone, this.email});
}


class Event {
  final String id;
  final String name;
  final String date;

  const Event({
    required this.id,
    required this.name,
    required this.date,
  });
}