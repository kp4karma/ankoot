

// Controller using GetX
import 'package:ankoot_new/api/server/general_service.dart';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodDistributionController extends GetxController {

  final Rx<FoodDistributionResponse?> _distributionData = Rx<FoodDistributionResponse?>(null);
  Rx<Pradesh> selectedPradesh = Pradesh(events: [],pradeshEngName: "",pradeshGujName: "",pradeshId: 0,pradeshUsers: [],status: "").obs;
  RxBool isShowLeftQty = false.obs;
  final RxBool _isLoading = true.obs;
  final RxString _error = ''.obs;
  final RxList<Event> _uniqueEvents = <Event>[].obs;
  final RxList<Pradesh> _uniquePradeshs = <Pradesh>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxList<FoodItem> _filteredItems = <FoodItem>[].obs;
  final RxString _selectedCategory = 'All'.obs;

  // Getters
  FoodDistributionResponse? get distributionData => _distributionData.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  List<Event> get uniqueEvents => _uniqueEvents;
  List<Pradesh> get uniquePradeshs => _uniquePradeshs;
  String get searchQuery => _searchQuery.value;
  List<FoodItem> get filteredItems => _filteredItems;
  String get selectedCategory => _selectedCategory.value;

  // Computed properties
  Map<String, dynamic> get summaryStats {
    if (_distributionData.value == null) return {};
    return FoodDistributionHelper.getSummaryStatistics(_distributionData.value!);
  }

  List<String> get categories {
    if (_distributionData.value == null) return ['All'];
    final cats = FoodDistributionHelper.extractUniqueCategories(_distributionData.value!);
    return ['All', ...cats];
  }

  @override
  void onInit() {
    super.onInit();
    loadData();

    // Listen to search query changes
    debounce(_searchQuery, (_) => _performSearch(), time: Duration(milliseconds: 500));
  }

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await GeneralService.getFoodDistributionData();

      if (response != null && response.errorStatus == false ) {
        _distributionData.value = response;
        _uniqueEvents.value = FoodDistributionHelper.extractUniqueEvents(response);
        _uniquePradeshs.value = FoodDistributionHelper.extractUniquePradeshs(response);
        _performSearch(); // Initialize filtered items

      } else {
        _error.value = response.msg ?? 'Failed to load data';

      }
    } catch (e) {
      _error.value = 'Network error: $e';

    } finally {
      _isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void setSelectedCategory(String category) {
    _selectedCategory.value = category;
    _performSearch();
  }

  void _performSearch() {
    if (_distributionData.value == null) return;

    List<FoodItem> items = FoodDistributionHelper.extractAllUniqueFoodItems(_distributionData.value!);

    // Filter by category
    if (_selectedCategory.value != 'All') {
      items = items.where((item) => item.foodCategory == _selectedCategory.value).toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      items = FoodDistributionHelper.searchItems(_distributionData.value!, _searchQuery.value);
      if (_selectedCategory.value != 'All') {
        items = items.where((item) => item.foodCategory == _selectedCategory.value).toList();
      }
    }

    _filteredItems.value = items;
  }

  void showEventDetails(Event event, [Pradesh? pradesh]) {
    Get.dialog(
      AlertDialog(
        title: Text(event.eventName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pradesh != null) ...[
                Text('Pradesh: ${pradesh.pradeshEngName}'),
                SizedBox(height: 8),
              ],
              Text('Total Items: ${event.items.length}'),
              Text('Total Assigned: ${event.totalAssignedQuantity}'),
              Text('Items with Shortage: ${event.itemsWithShortage.length}'),
              SizedBox(height: 16),
              Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...event.items.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(child: Text(item.foodEngName)),
                    Text(item.formattedAssigned),
                    Icon(
                      item.hasSufficientStock ? Icons.check : Icons.warning,
                      color: item.hasSufficientStock ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void refreshData() {
    loadData();
  }
}