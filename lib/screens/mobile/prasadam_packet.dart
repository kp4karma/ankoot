import 'package:ankoot_new/api/api_client.dart';
import 'package:ankoot_new/api/api_endpoints.dart';
import 'package:ankoot_new/controller/food_distribution_controller.dart';
import 'package:ankoot_new/models/PrasadmRecords.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:ankoot_new/widgets/search_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart' hide Response;

class PradeshPacketDistributionScreen extends StatefulWidget {

  final String? eventId;

  const PradeshPacketDistributionScreen({
    Key? key,

    this.eventId,
  }) : super(key: key);

  @override
  _PradeshPacketDistributionScreenState createState() =>
      _PradeshPacketDistributionScreenState();
}

class _PradeshPacketDistributionScreenState
    extends State<PradeshPacketDistributionScreen> {
  late List<PradeshWiseData> pradeshData;
  late List<PradeshWiseData> filteredPradeshData;
  PrasadmRecords? prasadmRecords;

  // Controllers
  TextEditingController searchController = TextEditingController();
  String? selectedPradeshId;

  // Loading states
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    pradeshData = [];
    filteredPradeshData = [];
    _loadPrasadData();
    searchController.addListener(_filterPradeshData);
  }

  void _filterPradeshData() {
    final query = searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredPradeshData = pradeshData;
      } else {
        filteredPradeshData = pradeshData.where((pradesh) {
          final pradeshName =
              pradesh.pradeshDetails?.pradeshEngName?.toLowerCase() ?? '';
          final pradeshGujName =
              pradesh.pradeshDetails?.pradeshGujName?.toLowerCase() ?? '';
          return pradeshName.contains(query) || pradeshGujName.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // API call to fetch prasad data
  Future<void> _loadPrasadData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await _callPrasadAPI(
        pradeshId: selectedPradeshId,
        eventId: widget.eventId,
      );

      if (response != null) {
        setState(() {
          prasadmRecords = response;
          pradeshData = response.data?.pradeshWiseData ?? [];
          filteredPradeshData = pradeshData;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  // API call method
  Future<PrasadmRecords?> _callPrasadAPI({
    String? pradeshId,
    String? eventId,
  }) async {
    try {
      Response response = await ApiClient.post(
        ApiEndpoints.getPrasadStock,
        data: {"event_id": 1},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.toString());
        return PrasadmRecords.fromJson(jsonData);
        // } else {
        //   throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  // Refresh data
  Future<void> _refreshData() async {
    await _loadPrasadData();
  }

  // Calculate totals from filtered data
  int get totalBoxes => filteredPradeshData.fold(
    0,
    (sum, item) => sum + (item.pradeshTotals?.totalBoxQty ?? 0),
  );
  int get totalPackets => filteredPradeshData.fold(
    0,
    (sum, item) => sum + (item.pradeshTotals?.totalPacketQty ?? 0),
  );
  int get totalDeliveredBoxes => filteredPradeshData.fold(
    0,
    (sum, item) => sum + (item.pradeshTotals?.totalDeliverBoxQty ?? 0),
  );
  int get totalDeliveredPackets => filteredPradeshData.fold(
    0,
    (sum, item) => sum + (item.pradeshTotals?.totalDeliverPacketQty ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildSearchAndFilter(),
          _buildSummaryCard(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(9),
      child: Column(
        children: [
          // Search Bar
          ReusableSearchBar(onChanged: (value) {
           setState(() {
             searchController.text = value;
            });
          },),

        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(8),
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
          _buildSummaryItem(
            'Total Boxes',
            totalBoxes,
            totalDeliveredBoxes,
            Colors.blue,
          ),
          SizedBox(height: 4),
          _buildSummaryItem(
            'Total Packet',
            totalBoxes + totalPackets,
            totalDeliveredBoxes + totalDeliveredPackets,
            Colors.brown,
          ),
          SizedBox(height: 4),

          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Red\nPackets',
                  totalPackets,
                  totalDeliveredPackets,
                  Colors.red,
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: _buildSummaryItem(
                  'Yellow\nPackets',
                  totalPackets,
                  totalDeliveredPackets,
                  Colors.yellow.shade900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading prasad data...'),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _refreshData, child: Text('Retry')),
          ],
        ),
      );
    }

    if (filteredPradeshData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty
                  ? 'No pradesh found matching "${searchController.text}"'
                  : 'No prasad data available',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _buildDataTable();
  }

  Widget _buildSummaryItem(
    String label,
    int totalValue,
    int deliveredValue,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 4),
          Text(
            "${totalValue.toString()} / $deliveredValue",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
          // Table Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                _buildHeaderCell('Sr.', flex: 1),
                _buildHeaderCell('Pradesh Name', flex: 4),
                _buildHeaderCell('Box', flex: 2, color: Colors.blue),
                _buildHeaderCell('Red Packets', flex: 2, color: Colors.red),
                _buildHeaderCell(
                  'Yellow Packets',
                  flex: 2,
                  color: Colors.yellow.shade900,
                ),
              ],
            ),
          ),

          // Table Data
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredPradeshData.length + 1, // +1 for total row
              itemBuilder: (context, index) {
                if (index == filteredPradeshData.length) {
                  return _buildTotalRow();
                }
                return _buildDataRow(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDataRow(int index) {
    final data = filteredPradeshData[index];
    final pradeshTotals = data.pradeshTotals;
    final pradeshDetails = data.pradeshDetails;


    return InkWell(
      onTap: () => _showDeliveryBottomSheet(context, data, index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Row(
          children: [
            _buildDataCell('${index + 1}', flex: 1),
            _buildDataCell(
              pradeshDetails?.pradeshEngName ?? 'Unknown Pradesh',
              flex: 4,
              isName: true,
            ),
            _buildDeliveryCell(
              pradeshTotals?.totalBoxQty ?? 0,
              pradeshTotals?.totalDeliverBoxQty ?? 0,
              flex: 2,
              color: Colors.blue.shade700,
            ),
            _buildDeliveryCell(
              pradeshTotals?.totalBoxQty ?? 0,
              pradeshTotals?.totalDeliverBoxQty ?? 0,
              flex: 2,
              color: Colors.red.shade700,
            ),
            _buildDeliveryCell(
              pradeshTotals?.totalPacketQty ?? 0,
              pradeshTotals?.totalDeliverPacketQty ?? 0,
              flex: 2,
              color: Colors.yellow.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 2)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell('', flex: 1),
          _buildDataCell("TOTAL", flex: 4, isName: true, isBold: true),
          _buildDeliveryCell(
            totalBoxes,
            totalDeliveredBoxes,
            flex: 2,
            color: Colors.blue.shade700,
            isBold: true,
          ),
          _buildDeliveryCell(
            totalBoxes,
            totalDeliveredBoxes,
            flex: 2,
            color: Colors.red.shade700,
            isBold: true,
          ),
          _buildDeliveryCell(
            totalPackets,
            totalDeliveredPackets,
            flex: 2,
            color: Colors.yellow.shade700,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCell(
    int totalQty,
    int deliveredQty, {
    required int flex,
    Color? color,
    bool isBold = false,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        children: [
          // Above divider - Total/Real count
          Text(
            '$totalQty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
          Divider(endIndent: 20, indent: 20, height: 0),
          // Below divider - Delivered count
          Text(
            '$deliveredQty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Show Pradesh Filter Dialog
  void _showPradeshFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Pradesh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All Pradesh'),
                leading: Radio<String?>(
                  value: null,
                  groupValue: selectedPradeshId,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    setState(() {
                      selectedPradeshId = value;
                    });
                    _loadPrasadData();
                  },
                ),
              ),
              ...pradeshData.map((pradesh) {
                final pradeshId = pradesh.pradeshDetails?.pradeshId?.toString();
                final pradeshName = pradesh.pradeshDetails?.pradeshEngName;
                return ListTile(
                  title: Text(pradeshName ?? 'Unknown'),
                  leading: Radio<String?>(
                    value: pradeshId,
                    groupValue: selectedPradeshId,
                    onChanged: (String? value) {
                      Navigator.pop(context);
                      setState(() {
                        selectedPradeshId = value;
                      });
                      _loadPrasadData();
                    },
                  ),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeliveryBottomSheet(
    BuildContext context,
    PradeshWiseData data,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeliveryBottomSheet(
        pradeshWiseData: data,
        onSave: (updatedData) async{

          setState(() {
            // Update in both original and filtered lists
            // final originalIndex = pradeshData.indexWhere(
            //   (item) =>
            //       item.pradeshDetails?.pradeshId ==
            //       updatedData.pradeshDetails?.pradeshId,
            // );
            // if (originalIndex != -1) {
            //   pradeshData[originalIndex] = updatedData;
            // }
            // filteredPradeshData[index] = updatedData;
          });
        },
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    required int flex,
    bool isName = false,
    bool isBold = false,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: isName ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: isName ? 14 : 15,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }
}

// Updated DeliveryBottomSheet remains the same
class DeliveryBottomSheet extends StatefulWidget {
  final PradeshWiseData pradeshWiseData;
  final Function(PradeshWiseData) onSave;

  const DeliveryBottomSheet({
    Key? key,
    required this.pradeshWiseData,
    required this.onSave,
  }) : super(key: key);

  @override
  _DeliveryBottomSheetState createState() => _DeliveryBottomSheetState();
}

class _DeliveryBottomSheetState extends State<DeliveryBottomSheet> {
  late TextEditingController boxController;
  late TextEditingController packetController;
  late TextEditingController deliveredBoxController;
  late TextEditingController deliveredPacketController;

  @override
  void initState() {
    super.initState();
    final totals = widget.pradeshWiseData.pradeshTotals;

    boxController = TextEditingController(
      text: (totals?.totalBoxQty ?? 0).toString(),
    );
    packetController = TextEditingController(
      text: (totals?.totalPacketQty ?? 0).toString(),
    );
    deliveredBoxController = TextEditingController(
      text: (totals?.totalDeliverBoxQty ?? 0).toString(),
    );
    deliveredPacketController = TextEditingController(
      text: (totals?.totalDeliverPacketQty ?? 0).toString(),
    );
  }

  @override
  void dispose() {
    boxController.dispose();
    packetController.dispose();
    deliveredBoxController.dispose();
    deliveredPacketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update ${widget.pradeshWiseData.pradeshDetails?.pradeshEngName ?? "Pradesh"}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
             SizedBox(height: 16),
              _buildTextField(
                'Delivered Boxes',
                deliveredBoxController,
                Colors.blue,
              ),
              SizedBox(height: 16),
          
              _buildTextField(
                'Delivered Packets',
                deliveredPacketController,
                Colors.red,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color color,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
      ),
    );
  }

  void _saveChanges() {

    print("ddd ${widget.pradeshWiseData.prasadRecords}");
    Map<String,dynamic> data = {
      "table":"prasadStock",
      "id":widget.pradeshWiseData.prasadRecords?.first.prasadId,
      "deliver_box_qty":  int.tryParse(deliveredBoxController.text) ?? 0,
      "deliver_packet_qty":  int.tryParse(deliveredPacketController.text) ?? 0,
      "person_name":"${UserStorageHelper.getUserData()?.data?.user?.userName.toString() ??"Admin"}",
      "person_mobile":"${UserStorageHelper.getUserData()?.data?.user?.userMobile.toString() ??"369"}"
    };


    print(data);

    final updatedTotals = PradeshTotals(
      totalBoxQty: int.tryParse(boxController.text) ?? 0,
      totalPacketQty: int.tryParse(packetController.text) ?? 0,
      totalDeliverBoxQty: int.tryParse(deliveredBoxController.text) ?? 0,
      totalDeliverPacketQty: int.tryParse(deliveredPacketController.text) ?? 0,
      totalRecords: widget.pradeshWiseData.pradeshTotals?.totalRecords ?? 0,
    );

    final updatedData = PradeshWiseData(
      pradeshDetails: widget.pradeshWiseData.pradeshDetails,
      prasadRecords: widget.pradeshWiseData.prasadRecords,
      pradeshTotals: updatedTotals,
    );

    widget.onSave(updatedData);
    Navigator.pop(context);
  }
}
