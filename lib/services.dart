// lib/services/data_service.dart



class DataService {



  Future<void> deleteItem(String itemId) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make HTTP request to delete item
  }

  Future<void> notifyUser(String userId, String message) async {
    // Mock notification service
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, would send push notification or email
  }
}