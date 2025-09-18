import 'package:ankoot_new/api/server/general_service.dart';
import 'package:ankoot_new/controller/food_distribution_controller.dart';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PrasadamWidget extends StatefulWidget {
  final String? eventId;
  PrasadStock prasadStock;

  PrasadamWidget({Key? key, this.eventId, required this.prasadStock})
    : super(key: key);

  @override
  State<PrasadamWidget> createState() => _PrasadamWidgetState();
}

class _PrasadamWidgetState extends State<PrasadamWidget> {
  FoodDistributionController foodDistributionController =
      Get.find<FoodDistributionController>();

  List<PrasadamItem> prasadamItems = [
    PrasadamItem(title: 'Prasad Box', key: 'box'),
    PrasadamItem(title: 'Prasad Packet', key: 'packet'),
  ];

  Map<String, TextEditingController> controllers = {};
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _addListeners();
  }

  void _initializeControllers() async {
    try {
      print("${foodDistributionController.selectedEventIndex}");
      print("selectedEvent.toJson() ${widget.prasadStock.toJson()}");
      controllers['box'] = TextEditingController(
        text: (widget.prasadStock.prasadBoxQty ?? "").toString().replaceAll(".00", ""),
      );
      controllers['packet'] = TextEditingController(
        text: (widget.prasadStock.prasadPacketQty ?? "").toString().replaceAll(".00", ""),
      );
    } catch (e) {
      // If no event found, initialize with empty values
      controllers['box'] = TextEditingController(text: "");
      controllers['packet'] = TextEditingController(text: "");
    }
  }

  void _addListeners() {
    controllers.forEach((key, controller) {
      controller.addListener(() {
        if (!_hasUnsavedChanges) {
          setState(() {
            _hasUnsavedChanges = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _savePrasadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final int boxQty = int.tryParse(controllers['box']?.text ?? '0') ?? 0;
      final int packetQty = int.tryParse(controllers['packet']?.text ?? '0') ?? 0;

      // ✅ Validation
      if (boxQty == 0 && packetQty == 0) {
        EasyLoading.showError("Please enter Prasad quantity (Box or Packet)!");
        setState(() => _isLoading = false);
        return;
      }

      final Map<String, dynamic> prasadData = {
        'prasad_box_qty': boxQty.toString(),
        'prasad_packet_qty': packetQty.toString(),
        'person_mobile':UserStorageHelper.getUserData()?.data?.user?.userMobile.toString(),
        'person_name':UserStorageHelper.getUserData()?.data?.user?.userName.toString(),
        'event_id': foodDistributionController.selectedEventIndex.value.toString(),
        'pradesh_id': UserStorageHelper.getUserData()
            ?.data
            ?.pradeshAssignment
            ?.pradeshId
            .toString() ??
            "",
      };

      // ✅ Always call one API
      final success = await GeneralService.savePrasadData(prasadData);

      if (success) {
        final selectedEvent = foodDistributionController.uniqueEvents.firstWhere(
              (element) =>
          element.eventId ==
              foodDistributionController.selectedEventIndex.value,
        );

        if (selectedEvent.prasadStock != null) {
          selectedEvent.prasadStock!.prasadBoxQty = boxQty.toString();
          selectedEvent.prasadStock!.prasadPacketQty = packetQty.toString();
        }

        setState(() {
          _hasUnsavedChanges = false;
        });

        await foodDistributionController.loadData();

        EasyLoading.showSuccess("Prasad data saved successfully!");
      } else {
        EasyLoading.showError("Something went wrong. Please try again!");
      }
    } catch (e) {
      EasyLoading.showError("Failed: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  int get _totalItems {
    int total = 0;
    controllers.forEach((key, controller) {
      total += int.tryParse(controller.text) ?? 0;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(thickness: 2),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: Colors.deepOrange,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prasadam Stock',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(thickness: 1, height: 24),

              // Header row
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Item Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              ...prasadamItems.map((item) => _buildDataRow(item,isEventExpired)).toList(),

              SizedBox(height: 16),

              if (!isEventExpired) ...[
                Row(
                  children: [
                    // Save button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _savePrasadData,
                        icon: _isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Icon(Icons.save, size: 18),
                        label: Text(_isLoading ? 'Saving...' : 'Save Stock'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    // Note
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.red.shade600,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "નોધ:- તા. ${DateFormat("dd-MM-yyyy").format(DateTime.parse(foodDistributionController.uniqueEvents.singleWhere(
                                (element) => element.eventId == foodDistributionController.selectedEventIndex.value,
                                orElse: () => Event(eventMaxPrasadDate: DateTime.now().toString(), eventItemLastDate: DateTime.now().toString(), eventId: 0, eventName: "", items: [], eventData: DateTime.now().toString(), status: "", prasadStock: PrasadStock(), totalItemsCount: 0),
                              ).eventMaxPrasadDate))} સુધીમાં તમારી પ્રસાદની સંખ્યા અપડેટ કરી દેવી.  ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.red.shade600, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "નોધ:- પ્રસાદની સંખ્યા અપડેટ કરવા માટે પ. આનંદસાગર સ્વામીજી અથવા પ. અનૂગ્રહ સ્વામીજીનો સંપર્ક કરવો.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  bool get isEventExpired {
    final selectedEvent = foodDistributionController.uniqueEvents.singleWhere(
      (element) =>
          element.eventId ==
          foodDistributionController.selectedEventIndex.value,
      orElse: () => Event(
        eventMaxPrasadDate: DateTime.now().toString(),
        eventItemLastDate: DateTime.now().toString(),
        eventId: 0,
        eventName: "",
        items: [],
        eventData: DateTime.now().toString(),
        status: "",
        prasadStock: PrasadStock(),
        totalItemsCount: 0,
      ),
    );

    final lastDate = DateTime.tryParse(selectedEvent.eventMaxPrasadDate);

    if (lastDate == null) return false; // invalid date → consider not expired

    return DateTime.now().isAfter(lastDate); // ✅ true if expired
  }

  Widget _buildDataRow(PrasadamItem item,bool isReadOnly) {
    return Container(
      key: UniqueKey(),
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon and Title
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.key == 'box'
                        ? Colors.blue.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    item.key == 'box' ? Icons.inventory_2 : Icons.card_giftcard,
                    color: item.key == 'box'
                        ? Colors.blue.shade600
                        : Colors.green.shade600,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Quantity TextField
          Expanded(
            flex: 2,
            child: TextField(
              controller: controllers[item.key],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }


}

// Enhanced model class for Prasadam items
class PrasadamItem {
  final String title;
  final String key;
  int total;

  PrasadamItem({required this.title, required this.key, this.total = 0});
}
