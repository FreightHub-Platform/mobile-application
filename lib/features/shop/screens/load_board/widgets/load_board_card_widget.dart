import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import '../confirm_load.dart';
import '../load_information.dart';
import 'load_board_info_field_widget.dart';

class TLoadBoardCard extends StatelessWidget {
  const TLoadBoardCard({
    super.key,
    required this.cardTitle,
    required this.consignor,
    required this.goodType,
    required this.totalDistance,
    required this.estimatedProfit,
  });

  final String cardTitle;
  final String consignor;
  final String goodType;
  final String totalDistance;
  final String estimatedProfit;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.sm),
      ),
      elevation: 5,
      color: TColors.white,
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Load Title
            Center(
              child: Text(cardTitle,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Load Information
            Text(TTexts.loadInfoTitle,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwItems),

            TLoadInfoField(title: TTexts.loadInfoConsignor, value: consignor),
            TLoadInfoField(title: TTexts.loadInfoGoodsType, value: goodType),
            TLoadInfoField(title: TTexts.loadInfoTotalDistance, value: totalDistance),
            TLoadInfoField( title: TTexts.loadInfoEstimatedProfit, value: estimatedProfit),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.black,
                padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
              ),
              onPressed: () => Get.to(() => const LoadInformationScreen()),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(TTexts.moreInfo),
                ],
              ),
            ),
            const SizedBox(height: TSizes.sm),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
              ),
              onPressed: () => Get.to(() => const ConfirmLoadScreen()),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(TTexts.bookLoadNow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}