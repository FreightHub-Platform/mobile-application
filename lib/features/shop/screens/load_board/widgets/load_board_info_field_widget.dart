import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class TLoadInfoField extends StatelessWidget {
  const TLoadInfoField({
    super.key, required this.title, required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}