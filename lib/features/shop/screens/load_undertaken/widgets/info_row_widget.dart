import 'package:flutter/material.dart';
import 'package:freight_hub/utils/constants/sizes.dart';

import '../../../../../utils/constants/colors.dart';

class TInfoRow extends StatelessWidget {
  const TInfoRow({
    super.key, required this.left, required this.right,
  });

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(left, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(right, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}