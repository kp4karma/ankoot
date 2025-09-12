
// lib/widgets/delivery_list_card.dart
import 'package:ankoot_new/models/user_model.dart';
import 'package:flutter/material.dart';

class DeliveryListCard extends StatelessWidget {
  final DeliveryListModel deliveryList;
  final VoidCallback? onTap;

  const DeliveryListCard({
    super.key,
    required this.deliveryList,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryList.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${deliveryList.itemCount} items',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      deliveryList.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (deliveryList.type.toLowerCase()) {
      case 'universal':
        return Colors.blue;
      case 'custom':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}