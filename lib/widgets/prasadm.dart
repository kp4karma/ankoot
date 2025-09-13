import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrasadamWidget extends StatefulWidget {
  const PrasadamWidget({Key? key}) : super(key: key);

  @override
  State<PrasadamWidget> createState() => _PrasadamWidgetState();
}

class _PrasadamWidgetState extends State<PrasadamWidget> {
  // List of prasadam items
  List<PrasadamItem> prasadamItems = [
    PrasadamItem(title: 'Prasad Box'),
    PrasadamItem(title: 'Prasad Packet'),
  ];

  // Controllers for managing text fields
  Map<int, TextEditingController> boxControllers = {};
  Map<int, TextEditingController> packetControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each item
    for (int i = 0; i < prasadamItems.length; i++) {
      boxControllers[i] = TextEditingController();

    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    boxControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _calculateTotal(int index) {
    final boxValue = int.tryParse(boxControllers[index]?.text ?? '') ?? 0;

    setState(() {
      prasadamItems[index].total = boxValue;
    });
  }

  int get grandTotal {
    return prasadamItems.fold(0, (sum, item) => sum + item.total);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Prasadam',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const Divider(thickness: 1),

            // Data rows
            ...prasadamItems.asMap().entries.map((entry) {
              int index = entry.key;
              PrasadamItem item = entry.value;
              return _buildDataRow(index, item);
            }).toList(),

            const Divider(thickness: 1),

            // Grand total row
            _buildGrandTotalRow(),
            SizedBox(height: 4,),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        child: Text(
                          "નોધ:- તા. 23-09-2025. સુધી માં AVD મંદિર એ મોકલી આપવું.",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Card(color: Colors.green.shade800,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                        child: Text("Save",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      ),)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Title',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Box',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildDataRow(int index, PrasadamItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Title
          Expanded(
            flex: 3,
            child: Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),

          // Box TextField
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                controller: boxControllers[index],
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.deepOrange, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  isDense: true,
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildGrandTotalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Grand Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withAlpha(20),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.deepOrange.shade200),
              ),
              child: Text(
                grandTotal.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for Prasadam items
class PrasadamItem {
  final String title;
  int total;

  PrasadamItem({
    required this.title,
    this.total = 0,
  });
}