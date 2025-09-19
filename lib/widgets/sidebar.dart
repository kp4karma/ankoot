// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/food_distribution_controller.dart';
import '../controller/pradesh_item_controller.dart';
import '../models/evet_items.dart';
import '../theme/app_theme.dart';
import '../widgets/search_bar.dart';

class Sidebar extends StatefulWidget {
  final Function(Pradesh) onPradeshSelected;
  final Pradesh? selectedPradesh;

  const Sidebar({
    super.key,
    required this.onPradeshSelected,
    this.selectedPradesh,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _searchQuery = '';

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
            child: ReusableSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildPradeshList(FoodDistributionController controller) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Pradesh> filteredPradeshs = controller.uniquePradeshs.where((p) {
          final engName = p.pradeshEngName?.toLowerCase() ?? '';
          final gujName = p.pradeshGujName?.toLowerCase() ?? '';
          return engName.contains(_searchQuery) || gujName.contains(_searchQuery);
        }).toList();

        if (filteredPradeshs.isEmpty) {
          return const Center(child: Text("No matching Pradesh found"));
        }



        return ListView.builder(
          itemCount: filteredPradeshs.length,
          itemBuilder: (context, index) {
            final pradesh = filteredPradeshs[index];
            final isSelected = controller.selectedPradesh.value.pradeshId == pradesh.pradeshId;

            return Obx(() => PradeshListItem(
              key: ValueKey('pradesh-${pradesh.pradeshId}'), // Use stable key
              pradesh: pradesh,
              isSelected: isSelected,
              hasEventMessage: (pradesh.events.singleWhere((element) => element.eventId == controller.selectedEventIndex.value,orElse: () => Event(eventId: 0, eventName: "", items: [], eventItemLastDate: "", eventMaxPrasadDate: "", eventData: "", isMessage: false, status: "", prasadStock: PrasadStock(), totalItemsCount: 0),).isMessage)??false,
              selectedEventIndex: controller.selectedEventIndex.value,
              onTap: () {
                controller.selectedPradesh.value = pradesh;
                widget.onPradeshSelected(pradesh);
              },
            ),);
          },
        );
      }),
    );
  }
}

// Separate widget for individual pradesh items to prevent unnecessary rebuilds
class PradeshListItem extends StatelessWidget {
  final Pradesh pradesh;
  final bool isSelected;
  final bool hasEventMessage;
  final int selectedEventIndex;
  final VoidCallback onTap;

  const PradeshListItem({
    super.key,
    required this.pradesh,
    required this.isSelected,
    required this.hasEventMessage,
    required this.selectedEventIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: hasEventMessage
            ? Colors.green.shade50
            : isSelected
            ? AppTheme.primaryColors.withOpacity(0.1)
            : Colors.transparent,
        border: isSelected
            ? Border.all(
          color: AppTheme.primaryColors.withOpacity(0.1),
          width: 1,
        )
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
          "${pradesh.pradeshEngName ?? ''} $selectedEventIndex",
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppTheme.primaryColors : Colors.black87,
          ),
        ),
        subtitle: Text(
          pradesh.pradeshGujName ?? '',
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppTheme.primaryColors : Colors.grey,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
      ),
    );
  }
}