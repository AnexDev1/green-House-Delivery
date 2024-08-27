import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;
  final bool isDarkMode;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.incrementQuantity,
    required this.decrementQuantity,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: Icon(Icons.remove,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: decrementQuantity,
          ),
        ),
        const SizedBox(width: 10),
        Text('$quantity'),
        const SizedBox(width: 10),
        Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xff3fb31e),
            border: Border.all(color: const Color(0xff3fb31e)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: incrementQuantity,
          ),
        ),
      ],
    );
  }
}
