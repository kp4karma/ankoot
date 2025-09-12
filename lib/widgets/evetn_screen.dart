import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

// Main Screen Widget
class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int selectedEventIndex = 0;
  List<EventItem> eventItems = [
    EventItem(id: 1, name: 'Meeting', date: '2024-01-15', status: 'Active'),
    EventItem(id: 2, name: 'Conference', date: '2024-01-20', status: 'Pending'),
    EventItem(id: 3, name: 'Workshop', date: '2024-01-25', status: 'Completed'),
    EventItem(id: 4, name: 'Training', date: '2024-02-01', status: 'Active'),
  ];

  List<ItemModel> items = [
    ItemModel(
      id: 1,
      nameEnglish: "Rice",
      nameGujarati: "ચોખા",
      unit: "Kg",
      qty: 2.5,
    ),
    ItemModel(
      id: 2,
      nameEnglish: "Wheat Flour",
      nameGujarati: "ઘઉંનો લોટ",
      unit: "Kg",
    ),
    ItemModel(
      id: 3,
      nameEnglish: "Sugar",
      nameGujarati: "ખાંડ",
      unit: "Kg",
      qty: 1.0,
    ),
    ItemModel(
      id: 4,
      nameEnglish: "Cooking Oil",
      nameGujarati: "રસોઈ તેલ",
      unit: "Ltr",
    ),
    ItemModel(
      id: 5,
      nameEnglish: "Salt",
      nameGujarati: "મીઠું",
      unit: "Kg",
      qty: 0.5,
    ),
  ];

  void _onSaveQty(int index, double qty) {
    setState(() {
      items[index].qty = qty;
    });
    // You can also call an API or save to database here
    print('Saved qty ${qty} for item: ${items[index].nameEnglish}');
  }


  final List<String> events = ['Diwali Ankoot - 2025', 'Ankoot - 2024'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Event Selection Card


        // Data Table Section
        Expanded(
          child: Container(
            // margin: EdgeInsets.all(16),
            // padding: EdgeInsets.all(16),
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
                  events: events,
                  selectedIndex: selectedEventIndex,
                  onEventSelected: (index) {
                    setState(() {
                      selectedEventIndex = index;
                    });
                  },
                  onAddNew: () {
                    _showAddEventDialog();
                  },
                ),
                Expanded(
                  child: ItemPlutoGrid(
                    items: items,
                    onSaveQty: _onSaveQty,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'Active':
        chipColor = Colors.green;
        break;
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Completed':
        chipColor = Colors.blue;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    // showDialog(
    //   context: context,
    //   builder: (context) => AddEventDialog(
    //     onEventAdded: (name, date) {
    //       setState(() {
    //         eventItems.add(EventItem(
    //           id: eventItems.length + 1,
    //           name: name,
    //           date: date,
    //           status: 'Pending',
    //         ));
    //       });
    //     },
    //   ),
    // );
  }

  void _editEvent(EventItem item) {
    // Handle edit event
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${item.name}')),
    );
  }

  void _deleteEvent(int id) {
    setState(() {
      eventItems.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event deleted')),
    );
  }
}

class EventSelectionCard extends StatelessWidget {
  final List<String> events;
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
        borderRadius: BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8)),
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
                  onTap: () => onEventSelected(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 120, // Minimum width for each tab
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: index == 0 ? BorderRadius.only(topLeft: Radius.circular(8),):BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        events[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[700],
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
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8),),
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

// Event Item Model
class EventItem {
  final int id;
  final String name;
  final String date;
  final String status;

  EventItem({
    required this.id,
    required this.name,
    required this.date,
    required this.status,
  });
}

// Add Event Dialog
class AddEventDialog extends StatefulWidget {
  final Function(String, String) onEventAdded;

  const AddEventDialog({Key? key, required this.onEventAdded}) : super(key: key);

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
            if (_nameController.text.isNotEmpty && _dateController.text.isNotEmpty) {
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
final List<ItemModel> items;
final Function(int index, double qty) onSaveQty;

const ItemPlutoGrid({
Key? key,
required this.items,
required this.onSaveQty,
}) : super(key: key);

@override
_ItemPlutoGridState createState() => _ItemPlutoGridState();
}

class _ItemPlutoGridState extends State<ItemPlutoGrid> {
  late PlutoGridStateManager stateManager;
  late List<PlutoColumn> columns;
  late List<PlutoRow> rows;

  @override
  void initState() {
    super.initState();
    _initializeColumns();
    _initializeRows();
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
        type: PlutoColumnType.number(
          negative: false,
          format: '#,###.##',
        ),
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
                  child: Icon(
                    Icons.save,
                    size: 16,
                    color: Colors.green[600],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  void _initializeRows() {
    rows = widget.items.asMap().entries.map((entry) {
      int index = entry.key;
      ItemModel item = entry.value;

      return PlutoRow(
        cells: {
          'sr': PlutoCell(value: index + 1),
          'nameEnglish': PlutoCell(value: item.nameEnglish),
          'nameGujarati': PlutoCell(value: item.nameGujarati),
          'qty': PlutoCell(value: item.qty ?? 0.0),
          'unit': PlutoCell(value: item.unit),
          'action': PlutoCell(value: ''),
        },
      );
    }).toList();
  }

  void _saveQuantity(int rowIndex) {
    if (rowIndex >= 0 && rowIndex < rows.length) {
      final qtyCell = rows[rowIndex].cells['qty'];
      final qty = qtyCell?.value ?? 0.0;

      if (qty is num && qty > 0) {
        widget.onSaveQty(rowIndex, qty.toDouble());

        // Update the original item
        if (rowIndex < widget.items.length) {
          widget.items[rowIndex].qty = qty.toDouble();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Quantity ${qty} saved for ${widget.items[rowIndex].nameEnglish}',
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid quantity greater than 0'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
        rows: rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager.setShowColumnFilter(false);
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
            // activatedColor: Colors.blue[50],
            gridBorderColor: Colors.grey[300]!,
            borderColor: Colors.grey[400]!,
            activatedBorderColor: Colors.blue,
            inactivatedBorderColor: Colors.grey[300]!,
            columnTextStyle: TextStyle(
              color: Colors.grey[800],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            cellTextStyle: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
            columnHeight: 45,
            rowHeight: 50,
            defaultColumnTitlePadding: EdgeInsets.symmetric(horizontal: 8),
            defaultCellPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
            resizeMode: PlutoResizeMode.normal,
          ),
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

// Usage Widget
class ItemPlutoGridPage extends StatefulWidget {
  @override
  _ItemPlutoGridPageState createState() => _ItemPlutoGridPageState();
}

class _ItemPlutoGridPageState extends State<ItemPlutoGridPage> {
  List<ItemModel> items = [
    ItemModel(
      id: 1,
      nameEnglish: "Rice",
      nameGujarati: "ચોખા",
      unit: "Kg",
      qty: 2.5,
    ),
    ItemModel(
      id: 2,
      nameEnglish: "Wheat Flour",
      nameGujarati: "ઘઉંનો લોટ",
      unit: "Kg",
    ),
    ItemModel(
      id: 3,
      nameEnglish: "Sugar",
      nameGujarati: "ખાંડ",
      unit: "Kg",
      qty: 1.0,
    ),
    ItemModel(
      id: 4,
      nameEnglish: "Cooking Oil",
      nameGujarati: "રસોઈ તેલ",
      unit: "Ltr",
    ),
    ItemModel(
      id: 5,
      nameEnglish: "Salt",
      nameGujarati: "મીઠું",
      unit: "Kg",
      qty: 0.5,
    ),
    ItemModel(
      id: 6,
      nameEnglish: "Turmeric Powder",
      nameGujarati: "હળદર પાવડર",
      unit: "Gm",
    ),
    ItemModel(
      id: 7,
      nameEnglish: "Red Chili Powder",
      nameGujarati: "લાલ મરચું પાવડર",
      unit: "Gm",
      qty: 0.25,
    ),
  ];

  void _onSaveQty(int index, double qty) {
    setState(() {
      if (index < items.length) {
        items[index].qty = qty;
      }
    });
    print('Saved qty ${qty} for item: ${items[index].nameEnglish}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Quantity Manager - PlutoGrid'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Double-click on Qty column to edit quantities, then click Save icon',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ItemPlutoGrid(
                items: items,
                onSaveQty: _onSaveQty,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Save all items with quantities
                    var itemsWithQty = items.where((item) => item.qty != null && item.qty! > 0).toList();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Items with Quantities'),
                        content: Container(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: itemsWithQty.map((item) =>
                                ListTile(
                                  title: Text(item.nameEnglish),
                                  subtitle: Text(item.nameGujarati),
                                  trailing: Text('${item.qty} ${item.unit}'),
                                )
                            ).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.list_alt),
                  label: Text('View All Quantities'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      for (var item in items) {
                        item.qty = null;
                      }
                    });
                    // Refresh the grid
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('All quantities cleared'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  icon: Icon(Icons.clear_all),
                  label: Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Data Model (same as before)
class ItemModel {
  final int id;
  final String nameEnglish;
  final String nameGujarati;
  final String unit;
  double? qty;

  ItemModel({
    required this.id,
    required this.nameEnglish,
    required this.nameGujarati,
    required this.unit,
    this.qty,
  });
}