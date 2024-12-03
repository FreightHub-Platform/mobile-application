import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/confirm_load.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import 'load_board_info_field_widget.dart';

class TLoadBoardInfoCard extends StatelessWidget {
  const TLoadBoardInfoCard({
    super.key,
    required this.consignor,
    required this.consignee,
    required this.pickupDate,
    required this.pickupTime,
    required this.dropOffDate,
    required this.dropOffTime,
    required this.goodType,
    required this.grossWeight,
    required this.totalDistance,
    required this.estFuelCost,
    required this.estimatedProfit,
    required this.profitPerKm,
    required this.title,
  });

  final String title;
  final String consignor;
  final String consignee;
  final String pickupDate;
  final String pickupTime;
  final String dropOffDate;
  final String dropOffTime;
  final String goodType;
  final String grossWeight;
  final String totalDistance;
  final String estFuelCost;
  final String estimatedProfit;
  final String profitPerKm;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
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
              child: Text(title,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Load Information
            Text(TTexts.loadInfoTitle,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwItems),

            TLoadInfoField(title: TTexts.loadInfoConsignor, value: consignor),
            TLoadInfoField(title: TTexts.loadInfoConsignee, value: consignee),
            TLoadInfoField(title: TTexts.loadInfoPickupDate, value: pickupDate),
            TLoadInfoField(title: TTexts.loadInfoPickupTime, value: pickupTime),
            TLoadInfoField(
                title: TTexts.loadInfoDropOffDate, value: dropOffDate),
            TLoadInfoField(
                title: TTexts.loadInfoDropOffTime, value: dropOffTime),
            TLoadInfoField(title: TTexts.loadInfoGoodsType, value: goodType),
            TLoadInfoField(
                title: TTexts.loadInfoGrossWeight, value: grossWeight),
            TLoadInfoField(
                title: TTexts.loadInfoTotalDistance, value: totalDistance),
            TLoadInfoField(
                title: TTexts.loadInfoEstFuelCost, value: estFuelCost),
            TLoadInfoField(
                title: TTexts.loadInfoEstimatedProfit, value: estimatedProfit),
            TLoadInfoField(
                title: TTexts.loadInfoProfitPerKm, value: profitPerKm),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Buttons
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: TColors.primary,
            //     padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
            //   ),
            //   onPressed: () => Get.to(() => const ConfirmLoadScreen()),
            //   child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(TTexts.bookLoadNow),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}