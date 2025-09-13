// lib/screens/mobile/mobile_home_screen.dart

import 'package:ankoot_new/controller/food_distribution_controller.dart';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:ankoot_new/widgets/prasadm.dart';
import 'package:ankoot_new/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

class MobileAdminHomeScreen extends StatefulWidget {
  const MobileAdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<MobileAdminHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileAdminHomeScreen> {
  FoodDistributionController foodDistributionController = Get.put(
    FoodDistributionController(),
  );

  // Create a list of GlobalKeys for each card
  final List<GlobalKey> _cardKeys = [];

  int selectedEventIndex = 1;

  bool isShare = false;

  int _selectedBottomIndex = 0;
  String _searchQuery = '';
  List<Pradesh> _filteredPradeshs = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _filterPradeshs();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _filterPradeshs() {
    if (_searchQuery.isEmpty) {
      _filteredPradeshs = foodDistributionController.uniquePradeshs.toList();
    } else {
      _filteredPradeshs = foodDistributionController.uniquePradeshs.where((
        pradesh,
      ) {
        // Search by pradesh name
        final pradeshNameMatch =
            pradesh.pradeshEngName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            pradesh.pradeshGujName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );

        // Search by food items in selected event
        final itemsMatch = pradesh.events
            .where((event) => event.eventId == selectedEventIndex)
            .expand((event) => event.items)
            .any(
              (item) =>
                  item.foodEngName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  item.foodGujName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            );

        print(itemsMatch);
        return pradeshNameMatch || itemsMatch;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventChipsRow(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ReusableSearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterPradeshs();
                  });
                },
              ),
            ),
            if (_selectedBottomIndex == 1)
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Text(
                            "Sr.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 5,
                          child: Text(
                            "Pradesh",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                            "Box",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                            "Packet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                            "Total",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 0),
                    ListView.builder(
                      itemCount: 5,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text(
                                      "${index + 1}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 5,
                                    child: Text(
                                      "Pradesh ${index + 1}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Text(
                                      "100",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Text(
                                      "50",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Text(
                                      "150",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 5,
                          child: Text(
                            "Total",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                            "500",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                            "250",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                            "750",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredPradeshs.length,
                  itemBuilder: (context, index) {
                    _cardKeys.add(GlobalKey());
                    Pradesh pradesh =
                        _filteredPradeshs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.deepOrange.withAlpha(30),
                        color: Colors.white,
                        child: Column(
                          children: [
                            RepaintBoundary(
                              key: _cardKeys[index],
                              child: Card(
                                elevation: 0,
                                shadowColor: Colors.black.withAlpha(30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MobileUserHeader(
                                        user: User(
                                          id: "${pradesh.pradeshId}",
                                          name: '${pradesh.pradeshGujName}',
                                          initials: '',
                                          contacts: pradesh.pradeshUsers
                                              .map(
                                                (e) => Contact(
                                                  name: e.userName,
                                                  phone: e.userMobile,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        onContactTap: _onContactTap,
                                        isShare: isShare,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 8,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                ),
                                                Flexible(
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
                                              itemCount: pradesh.events
                                                  .singleWhere(
                                                    (element) =>
                                                        element.eventId ==
                                                        selectedEventIndex,
                                                  )
                                                  .items
                                                  .length,
                                              itemBuilder: (context, itemIndex) {
                                                FoodItem foodItem = pradesh
                                                    .events
                                                    .singleWhere(
                                                      (element) =>
                                                          element.eventId ==
                                                          selectedEventIndex,
                                                    )
                                                    .items[itemIndex];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 1,
                                                        child: Text(
                                                          "${itemIndex + 1}",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                          "${foodItem.foodEngName}",
                                                          textAlign:
                                                              TextAlign.left,
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
                                                          "${foodItem.totalAssigned}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 2,
                                                        child: Text(
                                                          "${foodItem.totalQty}",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                          "${foodItem.foodUnit}",
                                                          textAlign:
                                                              TextAlign.center,
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "નોધ:- તા. 23-09-2025. સુધી માં AVD મંદિર એ મોકલી આપવું.",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: _buildActionButtons(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // PrasadamWidget(),
            SizedBox(height: kBottomNavigationBarHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedBottomIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.shade900 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavItem(0, Icons.home, 'Food Item'),
            _buildNavItem(1, Icons.restaurant, 'Prasad'),
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
          itemCount: foodDistributionController.uniqueEvents.length,
          itemBuilder: (context, index) {
            final isSelected = foodDistributionController.uniqueEvents[index].eventId == selectedEventIndex;
            return Padding(
              padding: EdgeInsets.only(
                right:
                    index < foodDistributionController.uniqueEvents.length - 1
                    ? 8
                    : 0,
              ),
              child: GestureDetector(
                onTap: () {
             
                  setState(() {
                    selectedEventIndex =
                        foodDistributionController.uniqueEvents[index].eventId;
                    _filterPradeshs();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
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
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.deepOrange.withAlpha(30),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      foodDistributionController.uniqueEvents[index].eventName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
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

  Widget _buildActionButtons(int cardIndex) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _shareCard(cardIndex),
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
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
              backgroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _showHistory,
            icon: const Icon(Icons.history, size: 18),
            label: const Text('History'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
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

  Future<void> _shareCard(int cardIndex) async {
    try {
      // Show loading
      setState(() {
        isShare = true;
      });
      _showLoadingDialog();

      // Wait for the next frame to ensure the widget is fully rendered
      await Future.delayed(const Duration(milliseconds: 100));

      // Use the specific card's key
      final cardKey = _cardKeys[cardIndex];

      // Now we can safely cast to RenderRepaintBoundary
      RenderRepaintBoundary boundary =
          cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/ankoot_${cardIndex}_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(pngBytes);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Share the image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Ankkot',
        subject: 'Ankkot',
      );
      setState(() {
        isShare = false;
      });
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
        content: Text('Send a notification to ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification sent to '),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.history, color: Colors.deepOrange),
            const SizedBox(width: 8),
            const Text('History'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent activity for :'),
            SizedBox(height: 16),
            Text('• Shared card - 2 hours ago'),
            Text('• Updated inventory - 1 day ago'),
            Text('• Sent notification - 3 days ago'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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

// All the existing model classes and widgets remain the same
class MobileUserHeader extends StatelessWidget {
  final User user;
  bool isShare;
  final Function(Contact)? onContactTap;

  MobileUserHeader({
    Key? key,
    required this.user,
    this.onContactTap,
    required this.isShare,
  }) : super(key: key);

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.contacts.isNotEmpty)
                    ContactChipList(
                      contacts: user.contacts,
                      onContactTap: onContactTap,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          borderRadius: BorderRadius.circular(8),
          color: Colors.deepOrange.withAlpha(10),
        ),
        child: Center(
          child: Text(
            "${contact.name} | ${contact.phone}",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

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

class Contact {
  final String name;
  final String phone;
  final String? email;

  const Contact({required this.name, required this.phone, this.email});
}
