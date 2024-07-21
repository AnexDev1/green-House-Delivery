import 'package:flutter/material.dart';

import '../models/cart_item.dart';

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
    return Column(
      children: [
        Stack(
          children: [
            ListTile(
              tileColor: Colors.black12,
              leading: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the corner radius
                child: Image.network(
                  item.imageUrl,
                  width: 56, // Adjust the width as needed
                  height: 56, // Adjust the height as needed
                  fit: BoxFit.cover, // Cover the bounds of the box
                ),
              ),
              title: Text(item.name),
              subtitle: Text('Quantity: ${item.quantity}'),
              trailing: Text('${item.price * item.quantity} birr'),
            ),
            Positioned(
              top: -8,
              right: -3,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.black),
                onPressed: () => onRemove(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
