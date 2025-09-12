// lib/widgets/add_item_button.dart
import 'package:flutter/material.dart';

class AddItemButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddItemButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onPressed,
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Add Item',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}