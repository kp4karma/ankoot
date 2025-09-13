// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/pradesh_item_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/search_bar.dart';
import '../models/pradesh_items_data_model.dart';

class Sidebar extends StatelessWidget {
  final Function(PradeshData) onPradeshSelected;
  final PradeshData? selectedPradesh;

  const Sidebar({
    super.key,
    required this.onPradeshSelected,
    this.selectedPradesh,
  });

  @override
  Widget build(BuildContext context) {
    final PradeshController pradeshController = Get.put(PradeshController());

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

  Widget _buildPradeshList(PradeshController controller) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.pradeshList.isEmpty) {
          return const Center(child: Text("No Pradesh found"));
        }

        return ListView.builder(
          itemCount: controller.pradeshList.length,
          itemBuilder: (context, index) {
            final pradesh = controller.pradeshList[index];
            final isSelected = selectedPradesh?.pradeshId == pradesh.pradeshId;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? AppTheme.primaryColors.withOpacity(0.1) : Colors.transparent,
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
                    color: isSelected ? AppTheme.primaryColors: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                title: Text(
                  pradesh.pradeshEngName ?? '',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ?AppTheme.primaryColors : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  "Items: ${pradesh.items?.length ?? 0} | Users: ${pradesh.pradeshUsers?.length ?? 0}",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppTheme.primaryColors : Colors.grey,
                  ),
                ),
           
                onTap: () => onPradeshSelected(pradesh),
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