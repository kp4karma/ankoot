// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/food_distribution_controller.dart';
import '../controller/pradesh_item_controller.dart';
import '../models/evet_items.dart';
import '../theme/app_theme.dart';
import '../widgets/search_bar.dart';

class Sidebar extends StatelessWidget {
  final Function(Pradesh) onPradeshSelected;
  final Pradesh? selectedPradesh;

  const Sidebar({
    super.key,
    required this.onPradeshSelected,
    this.selectedPradesh,
  });

  @override
  Widget build(BuildContext context) {
    final FoodDistributionController pradeshController = Get.put(FoodDistributionController());

    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          _buildPradeshList(pradeshController),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: ReusableSearchBar(onChanged: (value) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildPradeshList(FoodDistributionController controller) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        // Safe way to find a single element
        final pradesh = controller.uniquePradeshs.firstWhereOrNull(
              (p) => p.pradeshId == controller.selectedPradesh.value.pradeshId,
        );

        // If pradesh not found, show loading indicator
        if (pradesh == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.uniquePradeshs.length,
          itemBuilder: (context, index) {
            final pradesh = controller.uniquePradeshs[index];
            final isSelected =
                controller.selectedPradesh.value.pradeshId == pradesh.pradeshId;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? AppTheme.primaryColors.withOpacity(0.1)
                    : Colors.transparent,
                border: isSelected
                    ? Border.all(color: AppTheme.primaryColors.withOpacity(0.1), width: 1)
                    : null,
              ),
              child: ListTile(
                selected: isSelected,
                selectedTileColor: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColors.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: isSelected ? AppTheme.primaryColors : Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                title: Text(
                  pradesh.pradeshEngName ?? '',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryColors : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  " ${pradesh.pradeshGujName}",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppTheme.primaryColors : Colors.grey,
                  ),
                ),
                onTap: () {
                  controller.selectedPradesh.value = pradesh; // update selection
                  onPradeshSelected(pradesh); // callback
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}