import 'package:ankoot_new/widgets/evetn_screen.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert';

import '../theme/app_theme.dart';

class SweetItemsScreen extends StatefulWidget {
  static const routeName = 'feature/sweet-items-pradesh';

  const SweetItemsScreen({Key? key}) : super(key: key);

  @override
  _SweetItemsScreenState createState() => _SweetItemsScreenState();
}

class _SweetItemsScreenState extends State<SweetItemsScreen> {
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  // Sample JSON data - you can replace this with your actual data source
  final String sweetItemsJson = '''
  {
    "sweetItemsByPradesh": [
      {
        "pradeshName": "Maharashtra",
        "pradeshCode": "MH",
        "sweetItems": [
          {
            "itemId": "MH001",
            "itemName": "Modak",
            "assignedQty": 1000,
            "collectedQty": 750,
            "remainingQty": 250,
            "unit": "pieces",
            "category": "Traditional",
            "priority": "High"
          },
          {
            "itemId": "MH002",
            "itemName": "Puran Poli",
            "assignedQty": 500,
            "collectedQty": 300,
            "remainingQty": 200,
            "unit": "pieces",
            "category": "Traditional",
            "priority": "Medium"
          }
        ]
      },
      {
        "pradeshName": "Gujarat",
        "pradeshCode": "GJ",
        "sweetItems": [
          {
            "itemId": "GJ001",
            "itemName": "Dhokla",
            "assignedQty": 800,
            "collectedQty": 600,
            "remainingQty": 200,
            "unit": "pieces",
            "category": "Traditional",
            "priority": "High"
          }
        ]
      }
    ]
  }
  ''';

  @override
  void initState() {
    super.initState();
    _initializeColumns();
    _loadDataFromJson();
  }

  void _initializeColumns() {
    columns.addAll([
      PlutoColumn(
        title: 'Pradesh',
        field: 'pradesh',
        type: PlutoColumnType.text(),
        width: 120,
        enableRowDrag: false,
        enableRowChecked: false,
        renderer: (c) {
          IconData icon = c.row.type.isGroup ? Icons.location_city : Icons.store;
          Color iconColor = c.row.type.isGroup ? Colors.deepOrange : Colors.green;

          return Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  c.cell.value.toString(),
                  style: TextStyle(
                    fontWeight: c.row.type.isGroup ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: 'Item Name',
        field: 'itemName',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Assigned Qty',
        field: 'assignedQty',
        type: PlutoColumnType.number(format: '#,###'),
        width: 110,
        textAlign: PlutoColumnTextAlign.right,
      ),
      PlutoColumn(
        title: 'Collected Qty',
        field: 'collectedQty',
        type: PlutoColumnType.number(format: '#,###'),
        width: 110,
        textAlign: PlutoColumnTextAlign.right,
        renderer: (c) {
          final collected = c.cell.value as int? ?? 0;
          final assigned = c.row.cells['assignedQty']?.value as int? ?? 0;
          final percentage = assigned > 0 ? (collected / assigned * 100) : 0;

          Color textColor = Colors.black;
          if (percentage >= 80) {
            textColor = Colors.green;
          } else if (percentage >= 50) {
            textColor = Colors.orange;
          } else if (percentage < 50 && percentage > 0) {
            textColor = Colors.red;
          }

          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              collected.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Remaining Qty',
        field: 'remainingQty',
        type: PlutoColumnType.number(format: '#,###'),
        width: 110,
        textAlign: PlutoColumnTextAlign.right,
        renderer: (c) {
          final remaining = c.cell.value as int? ?? 0;
          Color backgroundColor = Colors.transparent;
          Color textColor = Colors.black;

          if (remaining == 0) {
            backgroundColor = Colors.green.withOpacity(0.1);
            textColor = Colors.green;
          } else if (remaining > 0) {
            backgroundColor = Colors.red.withOpacity(0.1);
            textColor = Colors.red;
          }

          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              remaining.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Unit',
        field: 'unit',
        type: PlutoColumnType.text(),
        width: 80,
      ),
      PlutoColumn(
        title: 'Call',
        field: 'call',
        type: PlutoColumnType.text(),
        width: 80,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (c) {
          if (c.row.type.isGroup) return const SizedBox();

          return Center(
            child: IconButton(
              icon: const Icon(Icons.phone, color: Colors.deepOrange, size: 20),
              onPressed: () => _handleCall(c.row),
              tooltip: 'Call for ${c.row.cells['itemName']?.value}',
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Notify',
        field: 'notify',
        type: PlutoColumnType.text(),
        width: 80,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (c) {
          if (c.row.type.isGroup) return const SizedBox();

          final remaining = c.row.cells['remainingQty']?.value as int? ?? 0;
          Color iconColor = remaining > 0 ? AppTheme.primaryColors : Colors.white;

          return Center(
            child: IconButton(
              icon: Icon(Icons.notifications, color: iconColor, size: 20),
              onPressed: remaining > 0 ? () => _handleNotify(c.row) : null,
              tooltip: 'Send notification for ${c.row.cells['itemName']?.value}',
            ),

          );
        },
      ),
    ]);
  }

  void _loadDataFromJson() {
    try {
      final Map<String, dynamic> data = jsonDecode(sweetItemsJson);
      final List<dynamic> pradeshData = data['sweetItemsByPradesh'];

      for (var pradesh in pradeshData) {
        // Create Pradesh group row
        final pradeshRow = PlutoRow(
          cells: {
            'pradesh': PlutoCell(value: '${pradesh['pradeshName']} (${pradesh['pradeshCode']})'),
            'itemName': PlutoCell(value: ''),
            'assignedQty': PlutoCell(value: 0),
            'collectedQty': PlutoCell(value: 0),
            'remainingQty': PlutoCell(value: 0),
            'unit': PlutoCell(value: ''),
            'call': PlutoCell(value: ''),
            'notify': PlutoCell(value: ''),
          },
          type: PlutoRowType.group(
            children: FilteredList<PlutoRow>(
              initialList: _createItemRows(pradesh['sweetItems']),
            ),
          ),
        );
        rows.add(pradeshRow);
      }
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  List<PlutoRow> _createItemRows(List<dynamic> items) {
    return items.map<PlutoRow>((item) {
      return PlutoRow(
        cells: {
          'pradesh': PlutoCell(value: item['itemName']),
          'itemName': PlutoCell(value: item['itemName']),
          'assignedQty': PlutoCell(value: item['assignedQty']),
          'collectedQty': PlutoCell(value: item['collectedQty']),
          'remainingQty': PlutoCell(value: item['remainingQty']),
          'unit': PlutoCell(value: item['unit']),
          'call': PlutoCell(value: ''),
          'notify': PlutoCell(value: ''),
        },
      );
    }).toList();
  }

  void _handleCall(PlutoRow row) {
    final itemName = row.cells['itemName']?.value ?? '';
    final remaining = row.cells['remainingQty']?.value ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Action'),
        content: Text('Calling for item: $itemName\nRemaining quantity: $remaining'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement actual call functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling for $itemName...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _handleNotify(PlutoRow row) {
    final itemName = row.cells['itemName']?.value ?? '';
    final remaining = row.cells['remainingQty']?.value ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Notification'),
        content: Text('Send notification for item: $itemName\nRemaining quantity: $remaining'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement actual notification functionality here
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

  int selectedEventIndex = 0;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
                    events: ['Diwali Ankoot - 2025', 'Ankoot - 2024'],
                    selectedIndex: selectedEventIndex,
                    onEventSelected: (index) {
                      setState(() {
                        selectedEventIndex = index;
                      });
                    },
                    onAddNew: () {
                      // _showAddEventDialog();
                    },
                  ),
                  Expanded(
                    child: PlutoGrid(
                      columns: columns,
                      rows: rows,
                      configuration: const PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
                          cellColorGroupedRow: Colors.deepOrange,
                          gridBorderColor: Colors.deepOrange,
                          activatedBorderColor: Colors.deepOrange,
                          rowHeight: 45,
                          columnHeight: 50,
                        ),
                        columnSize: PlutoGridColumnSizeConfig(
                          autoSizeMode: PlutoAutoSizeMode.none,
                          resizeMode: PlutoResizeMode.normal,
                        ),
                      ),
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        stateManager = event.stateManager;
                        stateManager.setRowGroup(
                          PlutoRowGroupTreeDelegate(
                            resolveColumnDepth: (column) => stateManager.columnIndex(column),
                            showText: (cell) => true,
                            showFirstExpandableIcon: true,
                          ),
                        );

                        // Auto-expand all groups
                        for (var row in rows) {
                          if (row.type.isGroup) {
                            stateManager.toggleExpandedRowGroup(rowGroup: row);
                          }
                        }
                      },
                      onChanged: (PlutoGridOnChangedEvent event) {
                        // Handle data changes if needed
                        print('Data changed: ${event.value}');
                      },
                    ),
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