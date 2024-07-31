import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TProgressBar extends StatelessWidget {
  const TProgressBar({
    super.key, required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value, // Adjust this value to set the progress
      backgroundColor: TColors.darkGrey,
      color: TColors.primary,
      minHeight: TSizes.lg / 2,
    );
  }
}