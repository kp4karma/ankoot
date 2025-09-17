
import 'package:ankoot_new/controller/event_controller.dart';
import 'package:ankoot_new/controller/food_distribution_controller.dart';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:ankoot_new/screens/mobile/history_user_screen.dart';
import 'package:ankoot_new/screens/mobile/login_screen.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:ankoot_new/widgets/prasadm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:get/get.dart';
class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  EventController eventController = Get.put(EventController());
  FoodDistributionController foodDistributionController = Get.put(
    FoodDistributionController(),
  );

  final GlobalKey _cardKey = GlobalKey();
  final List<GlobalKey> _cardKeys = [];

  bool isShare = false;
  String _searchQuery = '';
  List<Pradesh> _filteredPradeshs = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if(foodDistributionController.uniqueEvents.length >0){
      foodDistributionController.selectedEventIndex.value = foodDistributionController.uniqueEvents[0].eventId;
    }
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _filterPradeshs();
        if(foodDistributionController.uniqueEvents.length >0){
          foodDistributionController.selectedEventIndex.value = foodDistributionController.uniqueEvents[0].eventId;
        }

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

  @override
  Widget build(BuildContext context) {


    return  GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Obx(() {
            if(_filteredPradeshs.length ==0){
              _filterPradeshs();
            }

            return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MobileUserHeader(user: currentUser, onContactTap: _onContactTap),

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
                        child: ListView.builder(
                          primary: false,
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _filteredPradeshs.length,
                          itemBuilder: (context, index) {
                            _cardKeys.add(GlobalKey());
                            Pradesh pradesh = _filteredPradeshs[index];
                            return Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              shadowColor: Colors.deepOrange.withAlpha(30),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  if(pradesh.events
                                      .singleWhere(
                                        (element) =>
                                    element.eventId ==
                                        foodDistributionController.selectedEventIndex.value,
                                    orElse: () => Event(
                                      eventId: 0,
                                      eventName: "",
                                      items: [],  eventData: DateTime.now().toString(),
                                      status: "",
                                      totalItemsCount: 0,
                                    ),
                                  ).eventName != "")
                                    ...[ Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${pradesh.events
                                                .singleWhere(
                                                  (element) =>
                                              element.eventId ==
                                                  foodDistributionController.selectedEventIndex.value,
                                              orElse: () => Event(
                                                eventId: 0,
                                                eventData: DateTime.now().toString(),
                                                eventName: "",
                                                items: [],
                                                status: "",
                                                totalItemsCount: 0,
                                              ),
                                            ).eventName}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange,
                                            ),
                                          ),
                                          Text(
                                            "Event Date: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(pradesh.events
                                                .singleWhere(
                                                  (element) =>
                                              element.eventId ==
                                                  foodDistributionController.selectedEventIndex.value,
                                              orElse: () => Event(
                                                eventId: 0,
                                                eventName: "",
                                                items: [],  eventData: DateTime.now().toString(),
                                                status: "",
                                                totalItemsCount: 0,
                                              ),
                                            ).eventData))}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                      Divider(height: 0,),],
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
                                        child:           Builder(
                                          builder: (context) {
                                            final selectedEvent = pradesh.events
                                                .singleWhere(
                                                  (element) =>
                                              element.eventId ==
                                                  foodDistributionController.selectedEventIndex.value,
                                              orElse: () => Event(
                                                eventData: DateTime.now().toString(),
                                                eventId: 0,
                                                eventName: "",
                                                items: [],
                                                status: "",
                                                totalItemsCount: 0,
                                              ),
                                            );

                                            if (selectedEvent.items.isEmpty) {
                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "No Food Items found",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.brown,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            return Column(
                                              children: [
                                                SizedBox(height: 8),
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
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    if(foodDistributionController.isShowLeftQty.value == false)
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 2,
                                                        child: Text(
                                                          "Left Qty",
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
                                                        "Unit",
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
                                                Divider(),
                                                ListView.builder(
                                                  primary: false,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                  selectedEvent.items.length,
                                                  itemBuilder: (context, itemIndex) {
                                                    FoodItem foodItem =
                                                    selectedEvent
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
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                Colors.black,
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
                                                                color:
                                                                Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            fit: FlexFit.tight,
                                                            flex: 1,
                                                            child: Text(
                                                              "${foodItem.totalAssigned}",
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          if(foodDistributionController.isShowLeftQty.value == false)
                                                            Flexible(
                                                              fit: FlexFit.tight,
                                                              flex: 2,
                                                              child: Text(
                                                                "${foodItem.totalQty}",
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                  Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          Flexible(
                                                            fit: FlexFit.tight,
                                                            flex: 1,
                                                            child: Text(
                                                              "${foodItem.foodUnit}",
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),

                                                if (selectedEvent.status
                                                    .toString() ==
                                                    "active") ...[
                                                  Divider(),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
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
                                                                  color:
                                                                  Colors.red,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (foodDistributionController
                                                      .isShowLeftQty
                                                      .value ==
                                                      false)
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      child: _buildActionButtons(
                                                          index,
                                                          pradeshName:  pradesh.pradeshGujName,pradeshId: pradesh.pradeshId.toString(),eventId: selectedEvent.eventId.toString()
                                                      ),
                                                    ),
                                                ],
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                PrasadamWidget(),
                SizedBox(height: kBottomNavigationBarHeight,),
              ],
            );
          }),
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
            final isSelected =
                foodDistributionController.uniqueEvents[index].eventId ==
                    foodDistributionController.selectedEventIndex.value;
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
                    foodDistributionController.selectedEventIndex.value =
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

  void _filterPradeshs() {
    if (_searchQuery.isEmpty) {
      _filteredPradeshs = foodDistributionController.uniquePradeshs.toList();
    } else {
      _filteredPradeshs = foodDistributionController.uniquePradeshs.where((
          pradesh,
          ) {
        // Search by pradesh name
        final pradeshNameMatch =
        (pradesh.pradeshEngName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
                pradesh.pradeshGujName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ));

        // Search by food items in selected event
        final itemsMatch = pradesh.events
            .where((event) => event.eventId == foodDistributionController.selectedEventIndex.value)
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

    print("${UserStorageHelper.getUserData()?.data?.pradeshAssignment?.pradeshId}ddd");

    _filteredPradeshs.removeWhere((element) {
      print("${element.pradeshId}");
      return element.pradeshId != (UserStorageHelper.getUserData()?.data?.pradeshAssignment?.pradeshId??0);
    } ,);
  }
  Widget _buildActionButtons(int cardIndex,{String? eventId,String? pradeshId,String? pradeshName}) {
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
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => UserFoodItemsScreen(eventId: eventId??"",pradeshId: pradeshId??"",pradeshName: pradeshName??"",),));
            },
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



  Future<void> _shareCard(int cardIndex) async {
    try {
      foodDistributionController.isShowLeftQty.value = true;
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
    } finally {
      foodDistributionController.isShowLeftQty.value = false;
    }
  }




  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      title: const Text(
        "HP-Prasadam",
        style: TextStyle(letterSpacing: 1, color: Colors.white),
      ),
      actions: [

        IconButton(
          onPressed: (){
            UserStorageHelper.clearUserData();
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoginScreen(),));
          },
          icon: Icon(Icons.logout,color: Colors.white60,),
        ),
      ],
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


