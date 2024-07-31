import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/load_board.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';

class ConfirmLoadScreen extends StatelessWidget {
  const ConfirmLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.loadBoardTitle)),
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
                /// Title
                Text(TTexts.confirmLoadTitle, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: TSizes.spaceBtwSections),
                /// Message
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
                  child: Text(TTexts.confirmLoadSubTitle, style: Theme.of(context).textTheme.labelMedium)
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                /// Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        side: const BorderSide(
                            color: TColors.primary
                        ),
                      ),
                      onPressed: (){},
                      child: const Text(TTexts.confirmLoadTitle)
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.black,
                        side: const BorderSide(
                            color: TColors.black
                        ),
                      ),
                      onPressed: () => Get.off(() => const LoadBoardScreen()),
                      child: const Text(TTexts.cancel)
                  ),
                )

              ],
            ),
          ),
        ),

      ),
    );
  }
}
