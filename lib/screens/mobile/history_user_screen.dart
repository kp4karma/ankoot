import 'package:ankoot_new/api/history_service.dart';
import 'package:ankoot_new/models/user_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class UserFoodItemsScreen extends StatefulWidget {
  String pradeshName;
  String pradeshId;
  String eventId;
  UserFoodItemsScreen({Key? key, required this.eventId, required this.pradeshId, required this.pradeshName}) : super(key: key);

  @override
  _UserFoodItemsScreenState createState() => _UserFoodItemsScreenState();
}

class _UserFoodItemsScreenState extends State<UserFoodItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PersonWiseData> filteredUsers = [];
  List<PersonWiseData> allUsers = [];
  UserHistory? userHistoryData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserHistoryData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Replace this method with your actual API call
  void _loadUserHistoryData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // TODO: Replace with your actual API call
      UserHistory? response = await HistoryServices.fetchHistory(
        pradeshId: widget.pradeshId,
        eventId: widget.eventId,
      );

      // For now, using dummy data structure that matches UserHistory model
      userHistoryData = response;

      if (userHistoryData != null && userHistoryData!.data != null) {
        allUsers = userHistoryData!.data!.personWiseData ?? [];
        filteredUsers = List.from(allUsers);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: $e';
      });
    }
  }


  void _handleSearch(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((personData) {
          final userName = personData.personDetails?.personName?.toLowerCase() ?? '';
          final phoneNumber = personData.personDetails?.personMobile ?? '';
          final searchLower = searchText.toLowerCase();

          // Search in user details
          bool matchesUser = userName.contains(searchLower) || phoneNumber.contains(searchLower);

          // Search in food items
          bool matchesFoodItems = personData.foodItems?.any((foodItem) {
            final engName = foodItem.foodItemDetails?.foodEngName?.toLowerCase() ?? '';
            final gujName = foodItem.foodItemDetails?.foodGujName?.toLowerCase() ?? '';
            return engName.contains(searchLower) || gujName.contains(searchLower);
          }) ?? false;

          return matchesUser || matchesFoodItems;
        }).toList();
      }
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _handleSearch,
                decoration: InputDecoration(
                  hintText: 'Search by name, phone, or food item...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[400]),
                    onPressed: () {
                      _searchController.clear();
                      _handleSearch('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepOrange.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people,
                  size: 18,
                  color: Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredUsers.length} Users',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.pradeshName,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_outlined, size: 30, color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
                : errorMessage.isNotEmpty
                ? _buildErrorState()
                : filteredUsers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return UserFoodCard(
                  personData: filteredUsers[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Error Loading Data',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUserHistoryData,
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class UserFoodCard extends StatefulWidget {
  final PersonWiseData personData;
  final int index;

  const UserFoodCard({
    Key? key,
    required this.personData,
    required this.index,
  }) : super(key: key);

  @override
  _UserFoodCardState createState() => _UserFoodCardState();
}

class _UserFoodCardState extends State<UserFoodCard> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  DateTime _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null) return DateTime.now();
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final personDetails = widget.personData.personDetails;
    final foodItems = widget.personData.foodItems ?? [];
    final summary = widget.personData.summary;

    // Get the latest food item date for display
    DateTime latestDate = DateTime.now();
    if (foodItems.isNotEmpty) {
      latestDate = foodItems
          .map((item) => _parseDateTime(item.cdt))
          .reduce((a, b) => a.isAfter(b) ? a : b);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepOrange.withOpacity(0.1),
                        radius: 24,
                        child: Text(
                          (personDetails?.personName ?? 'U')
                              .split(' ')
                              .map((name) => name.isNotEmpty ? name[0] : '')
                              .take(2)
                              .join()
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              personDetails?.personName ?? 'Unknown User',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  personDetails?.personMobile ?? 'No phone',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a').format(latestDate),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restaurant, size: 14, color: Colors.deepOrange),
                            const SizedBox(width: 4),
                            Text(
                              '${foodItems.length} items',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: Colors.grey[50],
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Sr.',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Food Item',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Quantity',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Unit',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final item = foodItems[index];
                      final foodDetails = item.foodItemDetails;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: index < foodItems.length - 1
                                ? BorderSide(color: Colors.grey[200]!)
                                : BorderSide.none,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                foodDetails?.foodGujName ?? foodDetails?.foodEngName ?? 'Unknown Item',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                (item.foodQty).toString().replaceAll("-", "") ?? '0',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                foodDetails?.foodUnit ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}