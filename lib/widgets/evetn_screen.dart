import 'package:ankoot_new/models/evet_items.dart';
import 'package:ankoot_new/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';

import '../controller/food_distribution_controller.dart';

// Main Screen Widget
class EventScreen extends StatefulWidget {
  EventScreen({Key? key}) : super(key: key);
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int selectedEventIndex = 1;

  final foodDistributionController = Get.put(FoodDistributionController());

  void _onSaveQty(int index, double qty) {}

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
                  events: foodDistributionController.uniqueEvents,
                  selectedIndex: selectedEventIndex,
                  onEventSelected: (index) {
                    setState(() {
                      selectedEventIndex = index;
                    });
                  },
                  onAddNew: () {},
                ),
                Obx(
                  () => Expanded(
                    child: ItemPlutoGrid(
                      key: UniqueKey(),
                      items: foodDistributionController.uniquePradeshs
                          .singleWhere(
                            (element) =>
                                element.pradeshId ==
                                foodDistributionController
                                    .selectedPradesh
                                    .value
                                    .pradeshId,
                          )
                          .events
                          .singleWhere(
                            (element) => element.eventId == selectedEventIndex,
                          )
                          .items,
                      onSaveQty: _onSaveQty,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EventSelectionCard extends StatelessWidget {
  final List<Event> events;
  final int selectedIndex;
  final Function(int) onEventSelected;
  final VoidCallback onAddNew;

  const EventSelectionCard({
    Key? key,
    required this.events,
    required this.selectedIndex,
    required this.onEventSelected,
    required this.onAddNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                bool isSelected = index == selectedIndex;
                return InkWell(
                  onTap: () => onEventSelected(events[index].eventId),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 120, // Minimum width for each tab
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColors
                          : Colors.transparent,
                      borderRadius: index == 0
                          ? BorderRadius.only(topLeft: Radius.circular(8))
                          : BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColors
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        events[index].eventName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 0),
            child: ElevatedButton.icon(
              onPressed: onAddNew,
              icon: Icon(Icons.add, size: 18),
              label: Text('Add New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
                ),
                fixedSize: Size.fromHeight(36), // Fixed height for consistency
              ),
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
      title: Text('Add New Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Event Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
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
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _dateController.text.isNotEmpty) {
              widget.onEventAdded(_nameController.text, _dateController.text);
              Navigator.pop(context);
            }
          },
          child: Text('Add'),
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


  FoodDistributionController foodDistributionController = Get.find<FoodDistributionController>();
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
        enableEditingMode: true,
        width: 100,
        minWidth: 80,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        backgroundColor: Colors.blue[50],
      ),
      if(foodDistributionController.isShowLeftQty.value == true)
      PlutoColumn(
        title: 'Left Qty',
        field: 'left_qty',
        type: PlutoColumnType.number(negative: false, format: '#,###.##'),
        enableEditingMode: true,
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
          return Container(
            padding: EdgeInsets.all(4),
            child: Center(
              child: InkWell(
                onTap: () => _saveQuantity(rendererContext.rowIdx),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Icon(Icons.save, size: 16, color: Colors.green[600]),
                ),
              ),
            ),
          );
        },
      ),
    ];
  }


  void _saveQuantity(int rowIndex) {
    // if (rowIndex >= 0 && rowIndex < rows.length) {
    //   final qtyCell = rows[rowIndex].cells['qty'];
    //   final qty = qtyCell?.value ?? 0.0;
    //
    //   if (qty is num && qty > 0) {
    //     widget.onSaveQty(rowIndex, qty.toDouble());
    //
    //     // Update the original item
    //     if (rowIndex < widget.items.length) {
    //       // widget.items[rowIndex].totalAssigned = qty.toInt();
    //     }
    //
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           'Quantity ${qty} saved for ${widget.items[rowIndex].foodEngName}',
    //         ),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: Colors.green,
    //         behavior: SnackBarBehavior.floating,
    //       ),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Please enter a valid quantity greater than 0'),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: Colors.red,
    //         behavior: SnackBarBehavior.floating,
    //       ),
    //     );
    //   }
    // }
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
        rows:  widget.items.map((entry) {
          return PlutoRow(
            cells: {
              'sr': PlutoCell(value: entry.foodItemId + 1),
              'nameEnglish': PlutoCell(value: entry.foodEngName),
              'nameGujarati': PlutoCell(value: entry.foodGujName),
              'qty': PlutoCell(value: entry.totalAssigned ?? 0.0),
              'unit': PlutoCell(value: entry.foodUnit),
              if(foodDistributionController.isShowLeftQty.value == true)
                'left_qty': PlutoCell(value: entry.totalQty),
              'action': PlutoCell(value: ''),
            },
          );
        }).toList(),
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager.setShowColumnFilter(true);
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
            // scrollbarColor: Colors.grey[300],
            scrollbarThickness: 6,
          ),
          enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveDown,
          tabKeyAction: PlutoGridTabKeyAction.normal,
        ),
      ),
    );
  }
}
