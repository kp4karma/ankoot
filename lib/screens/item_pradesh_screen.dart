import 'package:ankoot_new/widgets/evetn_screen.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';

import '../controller/food_distribution_controller.dart';
import '../theme/app_theme.dart';

class ItemsPradeshScreen extends StatefulWidget {
  const ItemsPradeshScreen({Key? key}) : super(key: key);

  @override
  _ItemPradeshScreenState createState() => _ItemPradeshScreenState();
}

class _ItemPradeshScreenState extends State<ItemsPradeshScreen> {
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;

  final foodDistributionController = Get.put(FoodDistributionController());

  int selectedEventIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeColumns();

    // Load initial data if already available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (foodDistributionController.distributionData != null) {
        _loadDataFromController();
      }
    });
  }

  void _initializeColumns() {
    columns.addAll([
      PlutoColumn(
        title: 'Item Name',
        field: 'itemName',
        type: PlutoColumnType.text(),
        width: 200,
        enableRowDrag: false,
        readOnly: true,
        enableRowChecked: false,
        renderer: (c) {
          if(c.cell.value.toString() == "") return SizedBox();
          IconData icon = c.row.type.isGroup
              ? Icons.restaurant_menu
              : Icons.location_city;
          Color iconColor = c.row.type.isGroup
              ? Colors.deepOrange
              : Colors.green;

          return GestureDetector(
            onTap: () {
              if (c.row.type.isGroup) {
                stateManager?.toggleExpandedRowGroup(rowGroup: c.row);
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c.cell.value.toString(),
                      style: TextStyle(
                        fontWeight: c.row.type.isGroup
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Pradesh',
        field: 'pradesh',
        type: PlutoColumnType.text(),
        width: 150,
        readOnly: true,
        renderer: (c) => Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            c.cell.value.toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      PlutoColumn(
        title: 'Assigned Qty',
        field: 'assignedQty',
        type: PlutoColumnType.number(format: '#,###'),
        width: 110,
        textAlign: PlutoColumnTextAlign.right,
        readOnly: true,
        renderer: (c) => Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            c.cell.value.toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      PlutoColumn(
        title: 'Available Qty',
        field: 'availableQty',
        type: PlutoColumnType.number(format: '#,###'),
        width: 110,
        textAlign: PlutoColumnTextAlign.right,
        readOnly: true,
        renderer: (c) => Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            c.cell.value.toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      PlutoColumn(
        title: 'Shortage Qty',
        field: 'shortageQty',
        type: PlutoColumnType.number(format: '#,###'),
        width: 110,
        textAlign: PlutoColumnTextAlign.right,
        readOnly: true,
        renderer: (c) => Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            c.cell.value.toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      PlutoColumn(
        title: 'Unit',
        field: 'unit',
        type: PlutoColumnType.text(),
        width: 80,
        readOnly: true,
        renderer: (c) => Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            c.cell.value.toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      PlutoColumn(
        title: 'Notify',
        field: 'notify',
        type: PlutoColumnType.text(),
        width: 80,
        enableSorting: false,
        enableColumnDrag: false,
        readOnly: true,
        renderer: (c) {
          if (!c.row.type.isGroup) return const SizedBox();

          final shortage = c.row.cells['shortageQty']?.value as int? ?? 0;
          Color iconColor = shortage > 0 ? AppTheme.primaryColors : Colors.grey;

          return Center(
            child: IconButton(
              icon: Icon(Icons.notifications, color: iconColor, size: 20),
              onPressed: shortage > 0 ? () => _handleNotify(c.row) : null,
              tooltip:
              'Send notification for ${c.row.cells['itemName']?.value}',
            ),
          );
        },
      ),
    ]);
  }

  void _loadDataFromController() {
    if (!mounted) return;

    final distributionData = foodDistributionController.distributionData;
    if (distributionData == null) {
      print('DEBUG: Distribution data is null');
      return;
    }

    print(
      'DEBUG: Loading data with ${distributionData.pradeshs.length} pradeshs',
    );

    // Get the selected event
    final uniqueEvents = foodDistributionController.uniqueEvents;
    if (uniqueEvents.isEmpty) {
      print('DEBUG: No unique events available');
      setState(() {
        rows.clear();
      });
      return;
    }

    final selectedEvent = selectedEventIndex < uniqueEvents.length
        ? uniqueEvents[selectedEventIndex]
        : uniqueEvents.first;

    print(
      'DEBUG: Selected event: ${selectedEvent.eventName} (ID: ${selectedEvent.eventId})',
    );

    // Clear existing rows
    rows.clear();

    // Group data by Item Name for the selected event
    final itemMap = <String, Map<String, dynamic>>{};

    // Iterate through all pradeshs to collect items for the selected event
    for (var pradesh in distributionData.pradeshs) {
      if (!pradesh.isActive) continue; // Skip inactive pradeshs

      // Find events in this pradesh that match the selected event
      for (var event in pradesh.events) {
        if (event.eventId == selectedEvent.eventId) {
          print(
            'DEBUG: Found matching event in ${pradesh.pradeshEngName} with ${event.items.length} items',
          );

          // Process all items from this matching event
          for (var item in event.items) {
            final itemKey = item.foodGujName; // Use Gujarati name as key
            final shortage = item.totalAssigned > item.totalQty
                ? item.totalAssigned - item.totalQty
                : 0;

            if (!itemMap.containsKey(itemKey)) {
              itemMap[itemKey] = {
                'itemId': item.foodItemId.toString(),
                'itemName': item.foodGujName,
                'foodEngName': item.foodEngName,
                'unit': item.foodUnit,
                'pradeshs': <Map<String, dynamic>>[],
              };
            }

            // Add this pradesh's data to the item
            itemMap[itemKey]!['pradeshs'].add({
              'pradeshName': pradesh.pradeshEngName,
              'assignedQty': item.totalAssigned,
              'availableQty': item.totalQty,
              'shortageQty': shortage,
            });
          }
        }
      }
    }

    print('DEBUG: Created ${itemMap.length} item groups');

    // Create PlutoRows from the grouped data
    itemMap.forEach((itemName, itemData) {
      final pradeshs = itemData['pradeshs'] as List<Map<String, dynamic>>;

      // Create child rows for pradeshs
      final childRows = pradeshs.map<PlutoRow>((pradeshData) {
        return PlutoRow(
          cells: {
            'itemName': PlutoCell(value: ''),
            'pradesh': PlutoCell(value: pradeshData['pradeshName']),
            'assignedQty': PlutoCell(value: pradeshData['assignedQty']),
            'availableQty': PlutoCell(value: pradeshData['availableQty']),
            'shortageQty': PlutoCell(value: pradeshData['shortageQty']),
            'unit': PlutoCell(value: itemData['unit']),
            'notify': PlutoCell(value: ''),
          },
        );
      }).toList();

      // ✅ Calculate totals for this Item group
      final totalAssigned = pradeshs.fold<int>(
          0, (sum, pradesh) => sum + (pradesh['assignedQty'] as int));
      final totalAvailable = pradeshs.fold<int>(
          0, (sum, pradesh) => sum + (pradesh['availableQty'] as int));
      final totalShortage = pradeshs.fold<int>(
          0, (sum, pradesh) => sum + (pradesh['shortageQty'] as int));

      // Create Item group row with totals in header
      final itemRow = PlutoRow(
        cells: {
          'itemName': PlutoCell(value: itemName),
          'pradesh': PlutoCell(value: 'TOTAL'),
          'assignedQty': PlutoCell(value: totalAssigned),
          'availableQty': PlutoCell(value: totalAvailable),
          'shortageQty': PlutoCell(value: totalShortage),
          'unit': PlutoCell(value: itemData['unit']),
          'notify': PlutoCell(value: ''),
        },
        type: PlutoRowType.group(
          children: FilteredList<PlutoRow>(initialList: childRows),
        ),
      );

      rows.add(itemRow);
    });

    print('DEBUG: Created ${rows.length} total rows');

    // Update the grid if it's loaded
    if (stateManager != null && mounted) {
      _refreshGrid();
    }

    // Trigger UI update
    setState(() {});
  }

  void _refreshGrid() {
    if (stateManager == null) return;

    stateManager!.removeAllRows();
    stateManager!.appendRows(rows);
  }

  void _handleNotify(PlutoRow row) {
    final itemName = row.cells['itemName']?.value ?? '';
    final shortage = row.cells['shortageQty']?.value ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Notification'),
        content: Text(
          'Send notification for item: $itemName\nShortage quantity: $shortage',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notification sent for $itemName')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  EventSelectionCard(
                    events: foodDistributionController.uniqueEvents,
                    selectedIndex: selectedEventIndex,
                    onEventSelected: (index) {
                      setState(() {
                        selectedEventIndex = index;
                      });
                      _loadDataFromController();
                    },
                    onAddNew: () {
                      // _showAddEventDialog();
                    },
                  ),
                  Expanded(
                    child: Obx(() {
                      if (foodDistributionController.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange,
                          ),
                        );
                      }

                      if (foodDistributionController.error.isNotEmpty &&
                          foodDistributionController.error != "false") {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Error loading data',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    foodDistributionController.refreshData(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (foodDistributionController.uniqueEvents.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No events available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (rows.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No data available for the selected event',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return PlutoGrid(
                        columns: columns,
                        rows: rows,
                        configuration: PlutoGridConfiguration(
                          style: PlutoGridStyleConfig(
                            cellColorGroupedRow: Colors.deepOrange.withAlpha(10),
                            enableRowColorAnimation: true,
                            gridBorderColor: Colors.deepOrange,
                            activatedBorderColor: Colors.deepOrange,
                            rowHeight: 30,
                            columnHeight: 50,
                          ),
                          columnSize: PlutoGridColumnSizeConfig(
                            autoSizeMode: PlutoAutoSizeMode.scale,
                            resizeMode: PlutoResizeMode.normal,
                          ),
                        ),
                        onLoaded: (PlutoGridOnLoadedEvent event) {
                          stateManager = event.stateManager;

                          // Set up row grouping using TreeDelegate - now itemName is parent
                          stateManager?.setRowGroup(
                            PlutoRowGroupTreeDelegate(
                              resolveColumnDepth: (column) =>
                              column.field == 'itemName' ? 0 : 1,
                              showText: (cell) =>
                              cell.column.field == 'itemName',
                              showFirstExpandableIcon: true,
                            ),
                          );
                        },
                        onChanged: (PlutoGridOnChangedEvent event) {
                          print('Data changed: ${event.value}');
                        },
                      );
                    }),
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