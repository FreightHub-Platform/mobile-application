import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import '../confirm_load.dart';
import '../load_information.dart';
import 'load_board_info_field_widget.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';

class TLoadBoardCard extends StatelessWidget {
  final RouteModel route;
  final VoidCallback? onTap;
  final String? currentTab; // New parameter to track current tab

  const TLoadBoardCard({
    super.key,
    required this.route,
    this.onTap,
    this.currentTab, // Optional parameter to specify current tab
  });

  @override
  Widget build(BuildContext context) {
    // Conditions for showing/hiding buttons

    bool showBookLoadButton = false;
    if (currentTab == "Pending") showBookLoadButton = true;

    bool showMoreInfoButton = false;
    if (currentTab == 'Pending' || currentTab == 'Confirmed') showMoreInfoButton = true;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.sm),
      ),
      elevation: 5,
      color: TColors.white,
      child: ListTile(
        title: Center(
          child: Text(
            '${route.pickupPoint} - ${route.dropOff}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TSizes.spaceBtwItems),
            TLoadInfoField(title: TTexts.loadInfoConsignor, value: route.consignerName),
            TLoadInfoField(title: TTexts.loadInfoGoodsType, value: route.itemTypes.join(", ")),
            TLoadInfoField(title: TTexts.loadInfoTotalDistance, value: '${route.routeDistance} km'),
            TLoadInfoField(title: TTexts.loadInfoEstimatedProfit, value: 'LKR ${route.estdProfit}'),
            const SizedBox(height: TSizes.spaceBtwItems),
            if (showBookLoadButton)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ConfirmLoadDialog(route: route),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TTexts.bookLoadNow),
                  ],
                ),
              ),
            if (showMoreInfoButton)
              TextButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                ),
                onPressed: () => Get.to(() => LoadInformationScreen(route: route)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TTexts.moreInfo),
                  ],
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}