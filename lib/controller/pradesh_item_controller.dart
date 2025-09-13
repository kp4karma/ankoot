// lib/controllers/pradesh_controller.dart

import 'package:get/get.dart';
import '../api/server/general_service.dart';
import '../models/pradesh_items_data_model.dart';

class PradeshController extends GetxController {
  var isLoading = false.obs;
  var pradeshList = <PradeshData>[].obs;
  var errorMessage = ''.obs;

  // Add selected pradesh for default selection
  var selectedPradesh = Rx<PradeshData?>(null);

  /// Fetch Pradesh items for a given event
  Future<void> fetchPradeshItems(int eventId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await GeneralService.fetchPradeshItems(eventId);

      if (result != null && result.data != null) {
        pradeshList.assignAll(result.data!.data ?? []);

        // Automatically select first item if list is not empty and no item is selected
        if (pradeshList.isNotEmpty && selectedPradesh.value == null) {
          selectPradesh(pradeshList.first);
        }
      } else {
        errorMessage.value = "No data received from server.";
        pradeshList.clear();
        selectedPradesh.value = null; // Clear selection when no data
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      pradeshList.clear();
      selectedPradesh.value = null; // Clear selection on error
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a pradesh
  void selectPradesh(PradeshData pradesh) {
    selectedPradesh.value = pradesh;
  }

  /// Clear selected pradesh
  void clearSelection() {
    selectedPradesh.value = null;
  }

  /// Get currently selected pradesh
  PradeshData? get currentSelectedPradesh => selectedPradesh.value;

  /// Check if a pradesh is selected
  bool isPradeshSelected(PradeshData pradesh) {
    return selectedPradesh.value?.pradeshId == pradesh.pradeshId;
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    selectedPradesh.value = null;
    super.onClose();
  }
}