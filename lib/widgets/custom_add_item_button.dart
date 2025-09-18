import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/item_master_model.dart';

class AddItemDialog extends StatefulWidget {
  final List<ItemMasterData> availableItems;
  final Function(ItemMasterData, int qty) onItemAdded;

  const AddItemDialog({
    Key? key,
    required this.availableItems,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();

  ItemMasterData? _selectedItem;
  bool _isLoading = false;

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedItem == null) {
      _showSnackBar("Please select an item", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final qty = int.tryParse(_qtyController.text) ?? 0;
      widget.onItemAdded(_selectedItem!, qty);

      _showSnackBar("Item added successfully!", Colors.green);

      await Future.delayed(const Duration(milliseconds: 400));
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420, // ✅ limit dialog width for web
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Add Item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<ItemMasterData>(
                    value: _selectedItem,
                    isExpanded: true,
                    menuMaxHeight: 300,  // ✅ allow space for dropdown
                    decoration: InputDecoration(
                      labelText: "Select Item",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: widget.availableItems.map((item) {
                      return DropdownMenuItem<ItemMasterData>(
                        value: item,
                        child: Text(item.foodEngName ?? ""),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedItem = value),
                    validator: (value) =>
                    value == null ? "Item selection required" : null,
                  ),
          
          
                  const SizedBox(height: 16),
          
                  // Quantity field
                  TextFormField(
                    controller: _qtyController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Quantity required";
                      }
                      final qty = int.tryParse(value);
                      if (qty == null || qty <= 0) {
                        return "Enter valid quantity";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
          
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text("Save"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
