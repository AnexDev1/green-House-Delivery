import 'package:flutter/material.dart';

import '../../../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 4),
                Text(
                  '${item.price * item.quantity} birr',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.close, color: iconColor, size: 30),
              onPressed: () => onRemove(),
            ),
          ],
        ),
      ),
    );
  }
}
