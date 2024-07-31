import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;

  const UserAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18.0,
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.transparent,
    );
  }
}
