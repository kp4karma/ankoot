// lib/controllers/event_controller.dart

import 'package:get/get.dart';

import '../models/event.dart';


class EventController extends GetxController {
  final events = <Event>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSampleData();
  }

  void loadSampleData() {
    events.addAll([
      Event(
        id: '1',
        name: 'Diwali Celebration',
        description: 'Grand Diwali celebration with traditional food',
        date: DateTime.now().add(const Duration(days: 30)),
        location: 'Main Hall',
      ),
      Event(
        id: '2',
        name: 'Holi Festival',
        description: 'Colorful Holi celebration with special dishes',
        date: DateTime.now().add(const Duration(days: 60)),
        location: 'Community Center',
      ),
    ]);
  }

  void addEvent(Event event) {
    events.add(event);
    Get.back();
    Get.snackbar('Success', 'Event added successfully',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1));
  }

  void updateEvent(Event event) {
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
      Get.back();
      Get.snackbar('Success', 'Event updated successfully',
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1));
    }
  }

  void deleteEvent(String id) {
    events.removeWhere((event) => event.id == id);
    Get.snackbar('Success', 'Event deleted successfully',
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1));
  }

  void cloneEvent(Event event) {
    final clonedEvent = event.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${event.name} (Clone)',
      date: DateTime.now().add(const Duration(days: 7)),
    );
    events.add(clonedEvent);
    Get.snackbar('Success', 'Event cloned successfully',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1));
  }
}