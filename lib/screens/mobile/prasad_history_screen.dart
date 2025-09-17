import 'package:flutter/material.dart';

class PradeshPacketData {
  final String pradeshName;
  final int box;
  final int redPacket; // Always same as box
  final int yellowPacket; // Variable
  final int deliveredBox;
  final int deliveredRedPacket;
  final int deliveredYellowPacket;
  final int adminAssignedBox;
  final int adminAssignedRedPacket;
  final int adminAssignedYellowPacket;

  PradeshPacketData({
    required this.pradeshName,
    required this.box,
    required this.redPacket,
    required this.yellowPacket,
    required this.deliveredBox,
    required this.deliveredRedPacket,
    required this.deliveredYellowPacket,
    required this.adminAssignedBox,
    required this.adminAssignedRedPacket,
    required this.adminAssignedYellowPacket,
  });

  PradeshPacketData copyWith({
    String? pradeshName,
    int? box,
    int? redPacket,
    int? yellowPacket,
    int? deliveredBox,
    int? deliveredRedPacket,
    int? deliveredYellowPacket,
    int? adminAssignedBox,
    int? adminAssignedRedPacket,
    int? adminAssignedYellowPacket,
  }) {
    return PradeshPacketData(
      pradeshName: pradeshName ?? this.pradeshName,
      box: box ?? this.box,
      redPacket: redPacket ?? this.redPacket,
      yellowPacket: yellowPacket ?? this.yellowPacket,
      deliveredBox: deliveredBox ?? this.deliveredBox,
      deliveredRedPacket: deliveredRedPacket ?? this.deliveredRedPacket,
      deliveredYellowPacket:
          deliveredYellowPacket ?? this.deliveredYellowPacket,
      adminAssignedBox: adminAssignedBox ?? this.adminAssignedBox,
      adminAssignedRedPacket:
          adminAssignedRedPacket ?? this.adminAssignedRedPacket,
      adminAssignedYellowPacket:
          adminAssignedYellowPacket ?? this.adminAssignedYellowPacket,
    );
  }
}

class DeliveryBottomSheet extends StatefulWidget {
  final PradeshPacketData pradeshData;
  final Function(PradeshPacketData) onSave;

  const DeliveryBottomSheet({
    Key? key,
    required this.pradeshData,
    required this.onSave,
  }) : super(key: key);

  @override
  _DeliveryBottomSheetState createState() => _DeliveryBottomSheetState();
}

class _DeliveryBottomSheetState extends State<DeliveryBottomSheet> {
  late TextEditingController _boxController;
  late TextEditingController _redPacketController;
  late TextEditingController _yellowPacketController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _boxController = TextEditingController(
      text: widget.pradeshData.deliveredBox.toString(),
    );
    _redPacketController = TextEditingController(
      text: widget.pradeshData.deliveredRedPacket.toString(),
    );
    _yellowPacketController = TextEditingController(
      text: widget.pradeshData.deliveredYellowPacket.toString(),
    );
  }

  @override
  void dispose() {
    _boxController.dispose();
    _redPacketController.dispose();
    _yellowPacketController.dispose();
    super.dispose();
  }

  void _saveDelivery() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with your actual API call
      // await YourDeliveryService.updateDelivery(
      //   pradeshId: widget.pradeshData.pradeshId,
      //   deliveredBox: int.parse(_boxController.text),
      //   deliveredRedPacket: int.parse(_redPacketController.text),
      //   deliveredYellowPacket: int.parse(_yellowPacketController.text),
      // );

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      final updatedData = widget.pradeshData.copyWith(
        deliveredBox: int.parse(_boxController.text),
        deliveredRedPacket: int.parse(_redPacketController.text),
        deliveredYellowPacket: int.parse(_yellowPacketController.text),
      );

      // widgetFactory.onSave(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Delivery count updated successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Failed to update: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: Colors.deepOrange,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Delivery',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.pradeshData.pradeshName,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Input Fields
                    Expanded(
                      child: Column(
                        children: [
                          _buildInputField(
                            'Box Count',
                            _boxController,
                            widget.pradeshData.adminAssignedBox,
                            Colors.blue,
                            Icons.inventory,
                          ),
                          SizedBox(height: 16),
                          _buildInputField(
                            'Red Packet Count',
                            _redPacketController,
                            widget.pradeshData.adminAssignedRedPacket,
                            Colors.red,
                            Icons.card_giftcard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Action Bar
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveDelivery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Saving...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildStatusItem(
    String label,
    int delivered,
    int assigned,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          '$delivered/$assigned',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    int maxValue,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter count (max: $maxValue)',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: color),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a count';
            }
            final intValue = int.tryParse(value);
            if (intValue == null) {
              return 'Please enter a valid number';
            }
            if (intValue < 0) {
              return 'Count cannot be negative';
            }
            if (intValue > maxValue) {
              return 'Count cannot exceed $maxValue';
            }
            return null;
          },
        ),
      ],
    );
  }
}

