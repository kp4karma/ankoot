// lib/controllers/event_controller.dart

import 'package:get/get.dart';
import '../api/server/general_service.dart';
import '../models/event_data_model.dart'; // <-- your Data model

class EventController extends GetxController {
  final events = <Data>[].obs;   // <-- real Data model
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  /// Fetch events from backend
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final result = await GeneralService.fetchEvents();
      events.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new event locally (extend to API if needed)
  void addEvent(Data event) {
    events.add(event);
    Get.back();
    Get.snackbar(
      'Success',
      'Event added successfully',
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
    );
  }

  /// Update event locally
  void updateEvent(Data event) {
    final index = events.indexWhere((e) => e.eventId == event.eventId);
    if (index != -1) {
      events[index] = event;
      Get.back();
      Get.snackbar(
        'Success',
        'Event updated successfully',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      );
    }
  }

  /// Delete event locally
  void deleteEvent(int? id) {
    events.removeWhere((event) => event.eventId == id);
    Get.snackbar(
      'Success',
      'Event deleted successfully',
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
    );
  }

  /// Clone event locally
  void cloneEvent(Data event) {
    final clonedEvent = Data(
      eventId: DateTime.now().millisecondsSinceEpoch, // temporary ID
      eventName: '${event.eventName} (Clone)',
      eventDesc: event.eventDesc,
      eventLocation: event.eventLocation,
      eventDate: event.eventDate,
      status: event.status,
    );
    events.add(clonedEvent);
    Get.snackbar(
      'Success',
      'Event cloned successfully',
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
    );
  }
}
