// Model Classes for Food Distribution System - Flutter/Dart

class PradeshUser {
  final int userId;
  final String userName;
  final String userMobile;
  final String userPassword;
  final String userType;
  final String status;
  final String cdt;
  final String udt;

  PradeshUser({
    required this.userId,
    required this.userName,
    required this.userMobile,
    required this.userPassword,
    required this.userType,
    required this.status,
    required this.cdt,
    required this.udt,
  });

  factory PradeshUser.fromJson(Map<String, dynamic> json) {
    return PradeshUser(
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userMobile: json['user_mobile'] ?? '',
      userPassword: json['user_password'] ?? '',
      userType: json['user_type'] ?? '',
      status: json['status'] ?? '',
      cdt: json['cdt'] ?? '',
      udt: json['udt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_mobile': userMobile,
      'user_password': userPassword,
      'user_type': userType,
      'status': status,
      'cdt': cdt,
      'udt': udt,
    };
  }

  // Check if user is active
  bool get isActive => status == 'active';

  // Check if user is admin
  bool get isAdmin => userType == 'admin';

  // Check if user is regular user
  bool get isUser => userType == 'user';

  // Get formatted creation date
  DateTime? get createdAt {
    try {
      return DateTime.parse(cdt);
    } catch (e) {
      return null;
    }
  }

  // Get formatted update date
  DateTime? get updatedAt {
    try {
      return DateTime.parse(udt);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'PradeshUser(id: $userId, name: $userName, type: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PradeshUser && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}

class FoodItem {
  final int foodItemId;
  final String foodEngName;
  final String foodGujName;
  final String foodUnit;
  final String foodCategory;
  final int totalQty;
  final int totalAssigned;
  final int stockRecordsCount;

  FoodItem({
    required this.foodItemId,
    required this.foodEngName,
    required this.foodGujName,
    required this.foodUnit,
    required this.foodCategory,
    required this.totalQty,
    required this.totalAssigned,
    required this.stockRecordsCount,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodItemId: json['food_item_id'] ?? 0,
      foodEngName: json['food_eng_name'] ?? '',
      foodGujName: json['food_guj_name'] ?? '',
      foodUnit: json['food_unit'] ?? '',
      foodCategory: json['food_category'] ?? '',
      totalQty: json['total_qty'] ?? 0,
      totalAssigned: json['totalassigned'] ?? 0,
      stockRecordsCount: json['stock_records_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_item_id': foodItemId,
      'food_eng_name': foodEngName,
      'food_guj_name': foodGujName,
      'food_unit': foodUnit,
      'food_category': foodCategory,
      'total_qty': totalQty,
      'totalassigned': totalAssigned,
      'stock_records_count': stockRecordsCount,
    };
  }

  // Get formatted display name
  String getDisplayName({bool isGujarati = false}) {
    return isGujarati ? foodGujName : foodEngName;
  }

  // Check if item has sufficient stock
  bool get hasSufficientStock => totalQty >= totalAssigned;

  // Get stock deficit/surplus
  int get stockBalance => totalQty - totalAssigned;

  // Get formatted quantity with unit
  String get formattedQuantity => '$totalQty $foodUnit';

  // Get formatted assigned quantity with unit
  String get formattedAssigned => '$totalAssigned $foodUnit';

  @override
  String toString() {
    return 'FoodItem(id: $foodItemId, name: $foodEngName, qty: $totalQty $foodUnit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem && other.foodItemId == foodItemId;
  }

  @override
  int get hashCode => foodItemId.hashCode;
}

class Event {
  final int eventId;
  final String eventName;
  final List<FoodItem> items;
  final int totalItemsCount;

  Event({
    required this.eventId,
    required this.eventName,
    required this.items,
    required this.totalItemsCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] ?? 0,
      eventName: json['event_name'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => FoodItem.fromJson(item))
          .toList() ?? [],
      totalItemsCount: json['total_items_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'event_name': eventName,
      'items': items.map((item) => item.toJson()).toList(),
      'total_items_count': totalItemsCount,
    };
  }

  // Get items by category
  List<FoodItem> getItemsByCategory(String category) {
    return items.where((item) => item.foodCategory == category).toList();
  }

  // Get total assigned quantity for all items
  int get totalAssignedQuantity {
    return items.fold(0, (total, item) => total + item.totalAssigned);
  }

  // Get total available quantity for all items
  int get totalAvailableQuantity {
    return items.fold(0, (total, item) => total + item.totalQty);
  }

  // Get items with insufficient stock
  List<FoodItem> get itemsWithShortage {
    return items.where((item) => !item.hasSufficientStock).toList();
  }

  // Find item by ID
  FoodItem? findItemById(int itemId) {
    try {
      return items.firstWhere((item) => item.foodItemId == itemId);
    } catch (e) {
      return null;
    }
  }

  // Find items by name (supports both English and Gujarati)
  List<FoodItem> findItemsByName(String searchName) {
    final lowerSearch = searchName.toLowerCase();
    return items.where((item) =>
    item.foodEngName.toLowerCase().contains(lowerSearch) ||
        item.foodGujName.toLowerCase().contains(lowerSearch)
    ).toList();
  }

  @override
  String toString() {
    return 'Event(id: $eventId, name: $eventName, items: ${items.length})';
  }
}

  class Pradesh {
  final int pradeshId;
  final String pradeshEngName;
  final String pradeshGujName;
  final String status;
  final List<Event> events;
  final List<PradeshUser> pradeshUsers;


  Pradesh({
    required this.pradeshId,
    required this.pradeshEngName,
    required this.pradeshGujName,
    required this.status,
    required this.events,
    required this.pradeshUsers,
  });

  factory Pradesh.fromJson(Map<String, dynamic> json) {
    return Pradesh(
      pradeshId: json['pradesh_id'] ?? 0,
      pradeshEngName: (json['pradesh_eng_name'] ?? '').toString().trim(),
      pradeshGujName: json['pradesh_guj_name'] ?? '',
      status: json['status'] ?? '',
      pradeshUsers: (json['pradeshUsers'] as List<dynamic>?)
          ?.map((user) => PradeshUser.fromJson(user))
          .toList() ?? [],
      events: (json['events'] as List<dynamic>?)
          ?.map((event) => Event.fromJson(event))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pradesh_id': pradeshId,
      'pradesh_eng_name': pradeshEngName,
      'pradesh_guj_name': pradeshGujName,
      'status': status,
      'events': events.map((event) => event.toJson()).toList(),
      'pradeshUsers': pradeshUsers.map((user) => user.toJson()).toList(),
    };
  }

  // Get display name
  String getDisplayName({bool isGujarati = false}) {
    return isGujarati ? pradeshGujName : pradeshEngName;
  }

  // Check if pradesh is active
  bool get isActive => status == 'active';

  // Get event by ID
  Event? getEventById(int eventId) {
    try {
      return events.firstWhere((event) => event.eventId == eventId);
    } catch (e) {
      return null;
    }
  }

  // Get event by name
  Event? getEventByName(String eventName) {
    try {
      return events.firstWhere((event) => event.eventName == eventName);
    } catch (e) {
      return null;
    }
  }

  // Get total items across all events
  int get totalItemsCount {
    return events.fold(0, (total, event) => total + event.totalItemsCount);
  }

  // Get all unique food items across all events
  List<FoodItem> get allFoodItems {
    final List<FoodItem> allItems = [];
    for (var event in events) {
      allItems.addAll(event.items);
    }
    return allItems;
  }

  // Get food items by category across all events
  List<FoodItem> getFoodItemsByCategory(String category) {
    return allFoodItems.where((item) => item.foodCategory == category).toList();
  }

  @override
  String toString() {
    return 'Pradesh(id: $pradeshId, name: $pradeshEngName, events: ${events.length})';
  }
}

class FoodDistributionResponse {
  final bool errorStatus;
  final String msg;
  final int count;
  final List<Pradesh> pradeshs;

  FoodDistributionResponse({
    required this.errorStatus,
    required this.msg,
    required this.count,
    required this.pradeshs,
  });

  factory FoodDistributionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return FoodDistributionResponse(
      errorStatus: json['errorStatus'] ?? false,
      msg: data['msg'] ?? '',
      count: data['count'] ?? 0,
      pradeshs: (data['data'] as List<dynamic>?)
          ?.map((pradesh) => Pradesh.fromJson(pradesh))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorStatus': errorStatus,
      'data': {
        'msg': msg,
        'count': count,
        'data': pradeshs.map((pradesh) => pradesh.toJson()).toList(),
      },
    };
  }

  // Get active pradeshs only
  List<Pradesh> get activePradeshs {
    return pradeshs.where((pradesh) => pradesh.isActive).toList();
  }

  // Find pradesh by ID
  Pradesh? findPradeshById(int pradeshId) {
    try {
      return pradeshs.firstWhere((pradesh) => pradesh.pradeshId == pradeshId);
    } catch (e) {
      return null;
    }
  }

  // Find pradesh by name
  Pradesh? findPradeshByName(String name) {
    final lowerName = name.toLowerCase();
    try {
      return pradeshs.firstWhere((pradesh) =>
      pradesh.pradeshEngName.toLowerCase().contains(lowerName) ||
          pradesh.pradeshGujName.toLowerCase().contains(lowerName)
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'FoodDistributionResponse(pradeshs: ${pradeshs.length}, count: $count)';
  }
}

// Helper Functions
class FoodDistributionHelper {

  // Extract all unique events from the data
  static List<Event> extractUniqueEvents(FoodDistributionResponse response) {
    final Map<int, Event> uniqueEvents = {};

    for (var pradesh in response.pradeshs) {
      for (var event in pradesh.events) {
        if (!uniqueEvents.containsKey(event.eventId)) {
          uniqueEvents[event.eventId] = event;
        }
      }
    }

    return uniqueEvents.values.toList();
  }

  // Extract all unique pradeshs (active only by default)
  static List<Pradesh> extractUniquePradeshs(
      FoodDistributionResponse response, {
        bool activeOnly = true,
      }) {
    if (activeOnly) {
      return response.activePradeshs;
    }
    return response.pradeshs;
  }

  // Get all unique food items across all pradeshs and events
  static List<FoodItem> extractAllUniqueFoodItems(FoodDistributionResponse response) {
    final Map<int, FoodItem> uniqueItems = {};

    for (var pradesh in response.pradeshs) {
      for (var event in pradesh.events) {
        for (var item in event.items) {
          if (!uniqueItems.containsKey(item.foodItemId)) {
            uniqueItems[item.foodItemId] = item;
          }
        }
      }
    }

    return uniqueItems.values.toList();
  }

  // Get food items by category across all data
  static List<FoodItem> getFoodItemsByCategory(
      FoodDistributionResponse response,
      String category,
      ) {
    return extractAllUniqueFoodItems(response)
        .where((item) => item.foodCategory == category)
        .toList();
  }

  // Get all unique categories
  static List<String> extractUniqueCategories(FoodDistributionResponse response) {
    final Set<String> categories = {};

    for (var item in extractAllUniqueFoodItems(response)) {
      categories.add(item.foodCategory);
    }

    return categories.toList()..sort();
  }

  // Get summary statistics
  static Map<String, dynamic> getSummaryStatistics(FoodDistributionResponse response) {
    final allItems = extractAllUniqueFoodItems(response);
    final totalAssigned = allItems.fold(0, (sum, item) => sum + item.totalAssigned);
    final totalAvailable = allItems.fold(0, (sum, item) => sum + item.totalQty);
    final itemsWithShortage = allItems.where((item) => !item.hasSufficientStock).length;

    return {
      'totalPradeshs': response.pradeshs.length,
      'activePradeshs': response.activePradeshs.length,
      'totalEvents': extractUniqueEvents(response).length,
      'totalUniqueItems': allItems.length,
      'totalAssignedQuantity': totalAssigned,
      'totalAvailableQuantity': totalAvailable,
      'itemsWithShortage': itemsWithShortage,
      'shortagePercentage': allItems.isEmpty ? 0.0 : (itemsWithShortage / allItems.length) * 100,
    };
  }

  // Search items across all data
  static List<FoodItem> searchItems(
      FoodDistributionResponse response,
      String searchTerm,
      ) {
    final lowerSearch = searchTerm.toLowerCase();
    return extractAllUniqueFoodItems(response)
        .where((item) =>
    item.foodEngName.toLowerCase().contains(lowerSearch) ||
        item.foodGujName.toLowerCase().contains(lowerSearch)
    )
        .toList();
  }
}