import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddEventDialog extends StatefulWidget {
  final Function({
  required String eventDate,
  required String eventName,
  required String maxPrasadDate,
  required String itemLastDate,
  }) onEventAdded;

  const AddEventDialog({Key? key, required this.onEventAdded}) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _eventNameController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _maxPrasadDateController = TextEditingController();
  final _itemLastDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Focus nodes for better keyboard navigation
  final _eventNameFocusNode = FocusNode();
  final _eventDateFocusNode = FocusNode();
  final _maxPrasadDateFocusNode = FocusNode();
  final _itemLastDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus first field for better UX
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventNameFocusNode.requestFocus();
    });
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      // Better web styling
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Handle Enter key to submit
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _submitForm();
      }
      // Handle Escape key to cancel
      else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.pop(context);
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onEventAdded(
        eventName: _eventNameController.text,
        eventDate: _eventDateController.text,
        maxPrasadDate: _maxPrasadDateController.text,
        itemLastDate: _itemLastDateController.text,
      );
      Navigator.pop(context);
    }
  }

  String? _validateText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyPress,
      child: AlertDialog(
        // Better sizing for web
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            const Icon(Icons.event_note, color: Colors.blue),
            const SizedBox(width: 12),
            const Text(
              'Add Event',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: SizedBox(
          // Fixed width for better web layout
          width: MediaQuery.of(context).size.width > 600 ? 400 : double.maxFinite,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Event Name Field
                  TextFormField(
                    controller: _eventNameController,
                    focusNode: _eventNameFocusNode,
                    validator: (value) => _validateText(value, 'Event name'),
                    decoration: InputDecoration(
                      labelText: 'Event Name *',
                      hintText: 'Enter event name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_eventDateFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),


                  // Event Date Field
                  TextFormField(
                    controller: _eventDateController,
                    focusNode: _eventDateFocusNode,
                    readOnly: true,
                    validator: (value) => _validateDate(value, 'Event date'),
                    decoration: InputDecoration(
                      labelText: 'Event Date *',
                      hintText: 'Select event date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onTap: () => _pickDate(_eventDateController),
                  ),

                  const SizedBox(height: 16),

                  // Max Prasad Date Field
                  TextFormField(
                    controller: _maxPrasadDateController,
                    focusNode: _maxPrasadDateFocusNode,
                    readOnly: true,
                    validator: (value) => _validateDate(value, 'Max prasad date'),
                    decoration: InputDecoration(
                      labelText: 'Max Prasad Date *',
                      hintText: 'Select max prasad date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onTap: () => _pickDate(_maxPrasadDateController),
                  ),

                  const SizedBox(height: 16),

                  // Item Last Date Field
                  TextFormField(
                    controller: _itemLastDateController,
                    focusNode: _itemLastDateFocusNode,
                    readOnly: true,
                    validator: (value) => _validateDate(value, 'Item last date'),
                    decoration: InputDecoration(
                      labelText: 'Item Last Date *',
                      hintText: 'Select item last date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onTap: () => _pickDate(_itemLastDateController),
                  ),

                  const SizedBox(height: 8),

                  // Help text
                  Text(
                    '* Required fields',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel'),
              ),

              const SizedBox(width: 12),

              // Add Button
              ElevatedButton.icon(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Event'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateController.dispose();
    _maxPrasadDateController.dispose();
    _itemLastDateController.dispose();
    _eventNameFocusNode.dispose();
    _eventDateFocusNode.dispose();
    _maxPrasadDateFocusNode.dispose();
    _itemLastDateFocusNode.dispose();
    super.dispose();
  }
}