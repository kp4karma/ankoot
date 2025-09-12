// lib/services/data_service.dart
import '../models/user_model.dart';


class DataService {
  // Mock data - in a real app, this would come from an API or database

  List<UserModel> getUsers() {
    return [
      const UserModel(
        id: '1',
        name: 'Hari Sumiran',
        email: 'alice.j@example.com',
        phone: '555-0101',
        location: 'North Downtown',
      ),
      const UserModel(
        id: '2',
        name: 'Hari Tanay',
        email: 'bob.w@example.com',
        phone: '555-0102',
        location: 'South District',
      ),
      const UserModel(
        id: '3',
        name: 'Hari Sanmukh',
        email: 'anand.sagar@atmiya.org',
        phone: '555-0103',
        location: 'East Side',
      ),
    ];
  }

  List<DeliveryListModel> getDeliveryListsForUser(String userId) {
    // Mock data based on user
    switch (userId) {
      case '1':
        return [
          const DeliveryListModel(
            id: '1',
            name: 'Annakut 2025',
            itemCount: 0,
            type: 'UNIVERSAL',
          ),
        ];
      case '2':
        return [
          const DeliveryListModel(
            id: '2',
            name: 'Weekly Groceries',
            itemCount: 5,
            type: 'CUSTOM',
          ),
          const DeliveryListModel(
            id: '3',
            name: 'Office Supplies',
            itemCount: 3,
            type: 'TEMPLATE',
          ),
        ];
      case '3':
        return [
          const DeliveryListModel(
            id: '4',
            name: 'Special Event Items',
            itemCount: 8,
            type: 'UNIVERSAL',
          ),
        ];
      default:
        return [];
    }
  }

  List<DeliveryItemModel> getItemsForList(String listId) {
    // Mock items for lists
    switch (listId) {
      case '2':
        return [
          const DeliveryItemModel(
            id: '1',
            name: 'Milk',
            description: '2% Organic Milk - 1 gallon',
            category: 'Dairy',
          ),
          const DeliveryItemModel(
            id: '2',
            name: 'Bread',
            description: 'Whole wheat bread',
            category: 'Bakery',
          ),
          const DeliveryItemModel(
            id: '3',
            name: 'Apples',
            description: 'Red delicious apples - 2 lbs',
            category: 'Produce',
            isCompleted: true,
          ),
        ];
      case '3':
        return [
          const DeliveryItemModel(
            id: '4',
            name: 'Printer Paper',
            description: 'A4 white paper - 500 sheets',
            category: 'Office',
          ),
          const DeliveryItemModel(
            id: '5',
            name: 'Pens',
            description: 'Blue ballpoint pens - pack of 10',
            category: 'Office',
          ),
        ];
      default:
        return [];
    }
  }

  Future<void> createDeliveryList(DeliveryListModel list) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, would make HTTP request to create list
  }

  Future<void> addItemToList(String listId, DeliveryItemModel item) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make HTTP request to add item
  }

  Future<void> updateItem(DeliveryItemModel item) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make HTTP request to update item
  }

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