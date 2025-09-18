import 'package:get/get.dart';
import '../api/server/general_service.dart';
import '../helper/toast/toast_helper.dart';
import '../models/item_master_model.dart';

class ItemMasterController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var items = <ItemMasterData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems(); // ✅ Fetch data when controller initializes
  }
  /// Fetch Item Master Data from service
  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final result = await GeneralService.fetchItemMasterData();

      if (result.isNotEmpty) {
        items.assignAll(result);
      } else {
        items.clear();
      }
    } catch (e) {
      print("❌ [ItemMasterController] Error: $e");
      // 🔔 Show error toast/snackbar
      if (Get.context != null) {
        showToast(
          context: Get.context!,
          title: "Error",
          type: ToastType.error,
          message: "Failed to load items: $e",
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh items
  Future<void> refreshItems() async {
    await fetchItems();
  }

  /// Get items by category
  List<ItemMasterData> getItemsByCategory(String category) {
    return items.where((item) => item.foodCategory == category).toList();
  }

  /// Search items by name (English or Gujarati)
  List<ItemMasterData> searchItems(String query) {
    final q = query.toLowerCase();
    return items.where((item) =>
    (item.foodEngName ?? '').toLowerCase().contains(q) ||
        (item.foodGujName ?? '').toLowerCase().contains(q)
    ).toList();
  }

  /// Get unique categories
  List<String> get categories {
    final cats = items.map((item) => item.foodCategory ?? '').toSet().toList();
    cats.removeWhere((c) => c.isEmpty);
    cats.sort();
    return cats;
  }

  /// Find item by ID
  ItemMasterData? findById(int id) {
    try {
      return items.firstWhere((item) => item.foodItemId == id);
    } catch (_) {
      return null;
    }
  }
}
