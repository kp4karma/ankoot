// lib/controllers/event_controller.dart

import 'package:get/get.dart';
import '../api/server/event_service.dart';
import '../api/server/general_service.dart';
import '../models/event_data_model.dart';

class EventController extends GetxController {
  final events = <Data>[].obs;
  final isLoading = false.obs;
  RxBool isDefaultData = false.obs;

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

  /// Create new event (API + local list update)
  Future<bool> createNewEvent({
    required String eventName,
    required String personName,
    required String mobile,
    required String eventDate,
    required String maxPrasadDate,
    required String itemLastDate,
  }) async {
    try {
      isLoading.value = true;
      final success = await EventService.createNewEvent(
        eventName: eventName,
        personName: personName,
        mobile: mobile,
        eventDate: eventDate,
        maxPrasadDate: maxPrasadDate,
        itemLastDate: itemLastDate,
      );

      if (success) {
        // Refresh event list after creating new one
        await fetchEvents();

        Get.back(); // close dialog
        Get.snackbar(
          'Success',
          'Event created successfully',
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to create event',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        );
      }

      return success;
    } finally {
      isLoading.value = false;
    }
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

  /// Delete event locally (you can hook API delete here later)
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
