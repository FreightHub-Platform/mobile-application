import 'package:flutter/material.dart';
import 'package:freight_hub/utils/constants/colors.dart';
import 'package:freight_hub/utils/constants/texts.dart';

import '../../../utils/constants/sizes.dart';

class SuccessScreen2 extends StatelessWidget {
  const SuccessScreen2({
    super.key,
    required this.successTitle,
    required this.successSubTitle,
    required this.buttonMessage,
    required this.onPressed
  });

  final String successTitle;
  final String successSubTitle;
  final String buttonMessage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.md),
          ),
          elevation: 5,
          color: TColors.white,
          margin: const EdgeInsets.all(TSizes.defaultSpace),
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(successTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  successSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.lg, vertical: TSizes.lg / 2),
                    side: const BorderSide(color: TColors.primary),
                  ),
                  onPressed: onPressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(buttonMessage),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
