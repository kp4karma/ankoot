import 'dart:async';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:ankoot_new/theme/app_theme.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';

import '../controller/CRUD_controller.dart';
import '../controller/food_distribution_controller.dart';
import '../controller/item_master_controller.dart';
import '../helper/toast/toast_helper.dart';
import 'custom_add_item_button.dart';

// Main Screen Widget
class EventScreen extends StatefulWidget {

  EventScreen({Key? key, }) : super(key: key);
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  String searchQuery = '';

  final foodDistributionController = Get.put(FoodDistributionController());
  final itemMasterController = Get.put(ItemMasterController());

  @override
  void initState() {
    super.initState();
    _initializeData(); // ✅ Add this

  }

  void _initializeData() async {
    await itemMasterController.fetchItems(); // ✅ Fetch items on startup

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentPradesh = foodDistributionController.selectedPradesh.value;
    if (currentPradesh != null &&
        foodDistributionController.uniqueEvents.isNotEmpty) {
      setState(() {
        foodDistributionController.selectedEventIndex.value =
            foodDistributionController.uniqueEvents.first.eventId;
      });
    }
  }


  void _onSaveQty(int index, double qty) {}


  void _onSearch(String query) {
    print('Search query received in parent: $query'); // Debug log
    setState(() {
      searchQuery = query;
    });
  }

  List<FoodItem> _getFilteredItems() {
    print(
      'Getting filtered items for event:, search: "$searchQuery"',
    ); // Debug log

    // Get the selected pradesh
    final selectedPradesh = foodDistributionController.uniquePradeshs
        .where(
          (element) =>
              element.pradeshId ==
              foodDistributionController.selectedPradesh.value.pradeshId,
        )
        .firstOrNull;

    if (selectedPradesh == null) {
      print('No pradesh found'); // Debug log
      return [];
    }

    // Get the selected event
    final selectedEvent = selectedPradesh.events
        .where((element) => element.eventId == foodDistributionController.selectedEventIndex.value )
        .firstOrNull;

    if (selectedEvent == null) {
      print('No event found with ID:         foodDistributionController.selectedEventIndex.value '); // Debug log
      return [];
    }

    final items = selectedEvent.items;
    print('Total items found: ${items.length}'); // Debug log

    if (searchQuery.isEmpty) {
      return items;
    }

    // Apply search filter
    final filteredItems = items.where((item) {
      final query = searchQuery.toLowerCase().trim();
      final engName = item.foodEngName?.toLowerCase() ?? '';
      final gujName = item.foodGujName?.toLowerCase() ?? '';
      final unit = item.foodUnit?.toLowerCase() ?? '';

      final matches =
          engName.contains(query) ||
          gujName.contains(query) ||
          unit.contains(query);

      return matches;
    }).toList();

    print('Filtered items count: ${filteredItems.length}'); // Debug log
    return filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                EventSelectionCard(
                  key: ValueKey('event-${foodDistributionController.selectedEventIndex.value }'),
                  events: foodDistributionController.uniqueEvents,
                  selectedIndex:     foodDistributionController.selectedEventIndex.value,
                  onEventSelected: (index) {
                    setState(() {
                      foodDistributionController.selectedEventIndex.value = index;
                    });

                  },
                  onAddNew: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddEventDialog(
                        onEventAdded: (name, date) {
                          print('Event added: $name, $date');
                        },
                      ),
                    );
                  },
                  onSearch: _onSearch,
                  onAddItem: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Add Item functionality - implement as needed',
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                Obx(
                      () {
                    final pradeshId = foodDistributionController.selectedPradesh.value.pradeshId;
                    return Expanded(
                      child: ItemPlutoGrid(
                        key: UniqueKey(),
                        items: _getFilteredItems(),
                        onSaveQty: _onSaveQty,
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EventSelectionCard extends StatefulWidget {
  final List<Event> events;
  final int selectedIndex;
  final Function(int) onEventSelected;
  final VoidCallback onAddNew;
  final Function(String)? onSearch;
  final VoidCallback? onAddItem;

  const EventSelectionCard({
    Key? key,
    required this.events,
    required this.selectedIndex,
    required this.onEventSelected,
    required this.onAddNew,
    this.onSearch,
    this.onAddItem,
  }) : super(key: key);

  @override
  _EventSelectionCardState createState() => _EventSelectionCardState();
}

class _EventSelectionCardState extends State<EventSelectionCard> {
  late TextEditingController _searchController;
  final itemMasterController = Get.put(ItemMasterController());
  final foodDistributionController = Get.put(FoodDistributionController());

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    print('Search input changed: $value'); // Debug log
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      print('Debounced search: $value'); // Debug log
      widget.onSearch?.call(value); // 🔑 Pass to parent
    });
  }

  void _clearSearch() {
    print('Clearing search'); // Debug log
    _searchController.clear();
    widget.onSearch?.call(''); // 🔑 Reset search in parent
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
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
          // Tab Bar Section
          Container(
            height: 35,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.events.length,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          widget.events[index].eventId == widget.selectedIndex;

                      return Container(
                        margin: EdgeInsets.only(
                          right: index < widget.events.length - 1 ? 2 : 0,
                        ),
                        child: InkWell(
                          onTap: () => widget.onEventSelected(
                            widget.events[index].eventId,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            constraints: const BoxConstraints(minWidth: 120),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColors
                                  : Colors.grey[100],
                              borderRadius: index == 0
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                    )
                                  : BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryColors
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryColors
                                            .withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                widget.events[index].eventName,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: isSelected ? 14 : 13,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 0),
                  child:Obx(() => ElevatedButton.icon(
                    onPressed: itemMasterController.isLoading.value
                        ? null
                        : () {
                      if (itemMasterController.items.isEmpty) {
                        // Show message if no items
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No items available. Please check your connection.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      print("🔹 Opening AddItemDialog");
                      print("🔹 Selected Event ID: ${widget.selectedIndex}");
                      print("🔹 Selected Pradesh ID: ${foodDistributionController.selectedPradesh.value.pradeshId}");



                      showDialog(
                        context: context,
                        builder: (context) => AddItemDialog(
                          availableItems: itemMasterController.items.toList(),
                            onItemAdded: (item, qty) async {

                            print("${widget.selectedIndex.toString()}");
                            print("${foodDistributionController.selectedPradesh.value.pradeshId.toString()}");

                              // ✅ Call Insert API
                              final response = await PradeshController.insertPradeshData(
                                pradeshId: foodDistributionController.selectedPradesh.value.pradeshId.toString(),
                                eventId: widget.selectedIndex.toString(), // ✅ use widget.selectedIndex
                                itemId: item.foodItemId.toString(),
                                quantity: qty.toString(),
                                pradeshGujName: foodDistributionController.selectedPradesh.value.pradeshGujName ?? '',
                                pradeshEngName: foodDistributionController.selectedPradesh.value.pradeshEngName ?? '',
                                foodEngName: item.foodEngName ?? '',
                                foodGujName: item.foodGujName ?? '',
                                personName: UserStorageHelper.getUserData()!.data!.user!.userName.toString(),
                                personMobile: UserStorageHelper.getUserData()!.data!.user!.userMobile.toString(),
                              );

                              if (response == true) {
                                showToast(
                                  context: context,
                                  title: "Success",
                                  type: ToastType.success,
                                  message: "successfully added",
                                );

                                // Optionally refresh
                                await foodDistributionController.loadData();
                                setState(() {});
                              } else {
                                showToast(
                                  context: context,
                                  title: "Error",
                                  type: ToastType.error,
                                  message: "not added",
                                );
                              }
                            },


                        ),
                      );
                    },
                    icon: itemMasterController.isLoading.value
                        ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2)
                    )
                        : const Icon(Icons.add, size: 18),
                    label: Text(itemMasterController.isLoading.value ? 'Loading...' : 'Add New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                  ))
                  ,
                )

              ],
            ),
          ),

          // Search Bar Section
          Container(
            height: 45,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02)),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged, // ✅ This should work now
                      decoration: InputDecoration(
                        hintText: 'Search items by name or unit...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                onPressed: _clearSearch,
                                splashRadius: 12,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_searchController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColors.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppTheme.primaryColors.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Filtered',
                      style: TextStyle(
                        color: AppTheme.primaryColors,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add Event Dialog
class AddEventDialog extends StatefulWidget {
  final Function(String, String) onEventAdded;

  const AddEventDialog({Key? key, required this.onEventAdded})
    : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _dateController.text.isNotEmpty) {
              widget.onEventAdded(_nameController.text, _dateController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

class ItemPlutoGrid extends StatefulWidget {
  final List<FoodItem> items;
  final Function(int index, double qty) onSaveQty;

  const ItemPlutoGrid({Key? key, required this.items, required this.onSaveQty})
    : super(key: key);

  @override
  _ItemPlutoGridState createState() => _ItemPlutoGridState();
}

class _ItemPlutoGridState extends State<ItemPlutoGrid> {
  late PlutoGridStateManager stateManager;
  late List<PlutoColumn> columns;

  FoodDistributionController foodDistributionController =
      Get.find<FoodDistributionController>();

  @override
  void initState() {
    super.initState();
    _initializeColumns();
  }

  void _initializeColumns() {
    columns = [
      PlutoColumn(
        title: 'Sr.',
        field: 'sr',
        type: PlutoColumnType.number(),
        enableEditingMode: false,
        width: 60,
        minWidth: 50,
        backgroundColor: Colors.grey[50],
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'Item Name English',
        field: 'nameEnglish',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 150,
        minWidth: 120,
        titleTextAlign: PlutoColumnTextAlign.left,
        textAlign: PlutoColumnTextAlign.left,
      ),
      PlutoColumn(
        title: 'Item Name Gujarati',
        field: 'nameGujarati',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 150,
        minWidth: 120,
        titleTextAlign: PlutoColumnTextAlign.left,
        textAlign: PlutoColumnTextAlign.left,
      ),
      PlutoColumn(
        title: 'Qty',
        field: 'qty',
        type: PlutoColumnType.number(negative: false, format: '#,###.##'),
        enableEditingMode: false,
        width: 100,
        minWidth: 80,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        backgroundColor: Colors.blue[50],
      ),
      if (foodDistributionController.isShowLeftQty.value == true)
        PlutoColumn(
          title: 'Left Qty',
          field: 'left_qty',
          type: PlutoColumnType.number(negative: false, format: '#,###.##'),
          enableEditingMode: false,
          width: 100,
          minWidth: 80,
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          backgroundColor: Colors.blue[50],
        ),
      PlutoColumn(
        title: 'Unit',
        field: 'unit',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 80,
        minWidth: 60,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'Action',
        field: 'action',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 80,
        minWidth: 70,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          final rowIndex = rendererContext.rowIdx;
          final item = widget.items[rowIndex]; // 👈 get FoodItem from list

          return Container(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditItemDialog(
                      item: item,
                      onItemUpdated: (updatedItem) {
                        setState(() {
                          widget.items[rowIndex] = updatedItem;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item updated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.deepOrange[300]!),
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.deepOrange),
                ),
              ),
            ),
          );
        },
      ),

      PlutoColumn(
        title: 'Delete',
        field: 'delete',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 80,
        minWidth: 70,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          return Container(
            padding: EdgeInsets.all(4),
            child: Center(
              child: InkWell(
                onTap: () => _deleteRow(rendererContext.rowIdx),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: const Icon(Icons.delete, size: 16, color: Colors.red),
                ),
              ),
            ),
          );
        },
      ),

    ];
  }

  void _deleteRow(int rowIndex) {
    final item = widget.items[rowIndex];
    final foodDistributionController = Get.find<FoodDistributionController>();
    final selectedPradesh = foodDistributionController.selectedPradesh.value;
    final userData = UserStorageHelper.getUserData();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete "${item.foodGujName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ❌ Cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context); // close dialog first

                if (selectedPradesh == null || userData?.data?.user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Missing Pradesh or User Data'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // ✅ Call delete API
                final success = await PradeshController.deletePradeshItemData(
                  pradeshId: selectedPradesh.pradeshId.toString(),
                  eventId: foodDistributionController.uniqueEvents.first.eventId.toString(),
                  id: item.Id, // 👈 make sure FoodItem has Id field
                  personName: userData!.data!.user!.userName.toString(),
                  personMobile: userData.data!.user!.userMobile.toString(),
                );

                if (success) {
                  // 🔄 Refresh from server
                  await foodDistributionController.loadData();
                  if (mounted) setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.foodEngName} deleted successfully'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete ${item.foodEngName}'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: PlutoGrid(
        columns: columns,
        rows: widget.items.asMap().entries.map((entry) {
          int index = entry.key;
          FoodItem item = entry.value;
          return PlutoRow(
            key: UniqueKey(),
            cells: {
              'sr': PlutoCell(value: index + 1),
              'nameEnglish': PlutoCell(value: item.foodEngName),
              'nameGujarati': PlutoCell(value: item.foodGujName),
              'qty': PlutoCell(value: item.totalAssigned ?? 0.0),
              'unit': PlutoCell(value: item.foodUnit),
              if (foodDistributionController.isShowLeftQty.value == true)
                'left_qty': PlutoCell(value: item.totalQty),
              'action': PlutoCell(value: ''),
              'delete': PlutoCell(value: ''),
            },
          );
        }).toList(),
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          // Handle cell value changes
          if (event.column.field == 'qty') {
            print('Quantity changed: ${event.value}');
          }
        },
        configuration: PlutoGridConfiguration(
          style: PlutoGridStyleConfig(
            gridBackgroundColor: Colors.white,
            rowColor: Colors.white,
            oddRowColor: Colors.grey[50],
            gridBorderColor: Colors.grey[300]!,
            borderColor: Colors.grey[400]!,
            activatedColor: AppTheme.primaryColors.withOpacity(0.1),
            activatedBorderColor: AppTheme.primaryColors.withOpacity(0.7),
            inactivatedBorderColor: Colors.grey[300]!,
            columnTextStyle: TextStyle(
              color: Colors.grey[800],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            cellTextStyle: TextStyle(color: Colors.grey[700], fontSize: 12),
            columnHeight: 45,
            rowHeight: 50,
            defaultColumnTitlePadding: EdgeInsets.symmetric(horizontal: 8),
            defaultCellPadding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
          ),
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
            resizeMode: PlutoResizeMode.normal,
          ),
          columnFilter: PlutoGridColumnFilterConfig(),
          scrollbar: PlutoGridScrollbarConfig(
            isAlwaysShown: false,
            scrollbarThickness: 6,
          ),
          enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveDown,
          tabKeyAction: PlutoGridTabKeyAction.normal,
        ),
      ),
    );
  }
}

class EditItemDialog extends StatefulWidget {
  final FoodItem item;
  final Function(FoodItem updatedItem) onItemUpdated;

  const EditItemDialog({
    Key? key,
    required this.item,
    required this.onItemUpdated,
  }) : super(key: key);

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _nameEngController;
  late TextEditingController _nameGujController;
  late TextEditingController _qtyController;
  late TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _nameEngController =
        TextEditingController(text: widget.item.foodEngName ?? '');
    _nameGujController =
        TextEditingController(text: widget.item.foodGujName ?? '');
    _qtyController =
        TextEditingController(text: widget.item.totalAssigned?.toString() ?? '0');
    _unitController = TextEditingController(text: widget.item.foodUnit ?? '');
  }

  @override
  void dispose() {
    _nameEngController.dispose();
    _nameGujController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Edit Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameEngController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Item Name English',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameGujController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Item Name Gujarati',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _unitController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Unit',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () async {
            final foodDistributionController = Get.find<FoodDistributionController>();
            final selectedPradesh = foodDistributionController.selectedPradesh.value;
            final userData = UserStorageHelper.getUserData();

            if (selectedPradesh == null || userData?.data?.user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Missing Pradesh or User Data'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            // ✅ Call API
            final success = await PradeshController.updatePradeshItemData(
              id: widget.item.Id,
              pradeshId: selectedPradesh.pradeshId.toString(),
              eventId: foodDistributionController.uniqueEvents.first.eventId.toString(),
              itemId: widget.item.foodItemId.toString(),
              quantity: _qtyController.text,
              pradeshEngName: selectedPradesh.pradeshEngName ?? '',
              pradeshGujName: selectedPradesh.pradeshGujName ?? '',
              foodEngName: _nameEngController.text,
              foodGujName: _nameGujController.text,
              personName: userData!.data!.user!.userName.toString(),
              personMobile: userData.data!.user!.userMobile.toString(),
            );

            if (success) {
              // ✅ Refresh only from server (avoid double count)
              await foodDistributionController.loadData();
              if (mounted) setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update item'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            Navigator.pop(context);
          },
          child: const Text('Save'),
        )

      ],
    );
  }
}

