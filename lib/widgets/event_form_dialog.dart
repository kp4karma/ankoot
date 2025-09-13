// lib/widgets/event_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/event_controller.dart';
import '../models/event.dart';

class EventFormDialog extends StatefulWidget {
  final Event? event;

  const EventFormDialog({Key? key, this.event}) : super(key: key);

  @override
  State<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  final EventController controller = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _nameController.text = widget.event!.name;
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _selectedDate = widget.event!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event == null ? 'Add Event' : 'Edit Event',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey[600]
                              : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              if (_selectedDate == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select a date',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(widget.event == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final event = Event(
        id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
        location: _locationController.text,
      );

      if (widget.event == null) {
        // controller.addEvent(event);
      } else {
        // controller.updateEvent(event);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}