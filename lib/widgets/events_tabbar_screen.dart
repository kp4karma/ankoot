import 'dart:developer';

import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controller/event_controller.dart';
import '../models/event_data_model.dart'; // <-- use Data model
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

import 'add_event_dialog.dart';

class EventsScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events Management',
          style: TextStyle(color: AppTheme.primaryColors),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D3748),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showEventDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() {
          if (eventController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return eventController.events.isEmpty
              ? _buildEmptyState()
              : _buildEventsList();
        }),
      ),
    );
  }

  void _showEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        onEventAdded: ({
          required String eventName,
          required String eventDate,
          required String maxPrasadDate,
          required String itemLastDate,
        }) async {
          // Call EventController function here
          await eventController.createNewEvent(
            eventName: eventName, // 👉 Replace with dynamic input if needed
            personName: UserStorageHelper.getUserData()!.data!.user!.userName ?? "", // 👉 Replace with logged-in user or form field
            mobile: "6352411412",     // 👉 Replace with logged-in user or form field
            eventDate: eventDate,
            maxPrasadDate: maxPrasadDate,
            itemLastDate: itemLastDate,
          );
        },
      ),
    );
  }



  String formatDateTime(String? dbDate) {
    if (dbDate == null || dbDate.trim().isEmpty) {
      return "—"; // or return '' if you want it blank
    }

    try {
      DateTime parsedUtc = DateTime.parse(dbDate); // throws FormatException if invalid
      DateTime local = parsedUtc.toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(local);
    } catch (e) {
      // fallback for invalid strings
      return dbDate;
    }
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.primaryColors.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note,
              size: 64,
              color: AppTheme.primaryColors,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Events Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColors,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first event to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showEventDialog(Get.context!),
            icon: const Icon(Icons.add),
            label: const Text('Create Event'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColors,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return _buildDesktopGrid();
  }

  Widget _buildMobileList() {
    return ListView.builder(
      itemCount: eventController.events.length,
      itemBuilder: (context, index) {
        final Data event = eventController.events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.event,
                color: Color(0xFF1976D2),
              ),
            ),
            title: Text(event.eventName ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.eventDesc ?? ''),
                const SizedBox(height: 4),
                Text(
                  '${event.eventDate ?? ''} - ${event.eventLocation ?? ''}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value, event),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete',
                        style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopGrid() {


    return ResponsiveGridView.builder(
      gridDelegate: const ResponsiveGridDelegate(
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        maxCrossAxisExtent: 400,
        childAspectRatio: 1.5 / 1,
      ),
      itemCount: eventController.events.length,
      itemBuilder: (context, index) {
        final Data event = eventController.events[index];
        log("iwebdbciebc${event.eventDate}");
        return Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1976D2).withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(value, event),
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Delete',
                                style: TextStyle(color: Colors.red)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  event.eventName ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Event Date : ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // 🔥 Bold label
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: formatDateTime(event.eventDate ?? ''),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600], // normal text
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Max Prasad Date : ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: formatDateTime(event.eventMaxPrasadDate ?? ''),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Item Last Date : ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: formatDateTime(event.eventItemLastDate ?? ''),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),


              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMenuAction(String action, Data event) {
    switch (action) {
      case 'edit':
        _showEventDialog(Get.context!);
        break;
      case 'delete':
        _showDeleteDialog(event);
        break;
    }
  }


  void _showDeleteDialog(Data event) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.eventName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              eventController.deleteEvent(event.eventId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
