import 'package:flutter/material.dart';
import 'package:freight_hub/common/widgets/otp_screen/otp_screen.dart';
import 'package:freight_hub/features/shop/screens/load_in_transit/po_completed.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/call_info_row_widget.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/info_row_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';

class LoadInTransitScreen extends StatelessWidget {
  const LoadInTransitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TTexts.loadInTransit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.sm),
                ),
                color: TColors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('Biyagama - Katunayake', style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.black,
                            padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                            side: const BorderSide(color: TColors.black)
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(TTexts.jobSummaryTitle),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const TInfoRow(left: 'Current Delivery', right: 'Total Distance Remaining'),
                      const TInfoRow(left: '*****', right: '*****'),
                      const TInfoRow(left: 'Remaining P.O.s', right: ''),
                      const TInfoRow(left: '*****', right: ''),

                      const SizedBox(height: TSizes.spaceBtwItems),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: TSizes.lg / 2, horizontal: TSizes.lg),
                          decoration: const BoxDecoration(
                            color: TColors.info, // Replace with your color
                            // borderRadius: BorderRadius.circular(TSizes.md),
                          ),
                          child: Text(TTexts.loadInProgress, style: Theme.of(context).textTheme.titleMedium
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(width: 8),
                    Text(TTexts.openInGoogleMap),
                    Spacer(),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Text(TTexts.loadInfoConsignor, style: Theme.of(context).textTheme.headlineSmall),
              const TCallInfoRow(location: 'Ocean Lanka Pvt. Ltd'),
              const SizedBox(height: TSizes.spaceBtwItems),

              Text(TTexts.loadInfoConsignee, style: Theme.of(context).textTheme.headlineSmall),
              const TCallInfoRow(location: 'MAS Linea Aqua Pvt. Lt'),
              const SizedBox(height: TSizes.spaceBtwSections),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                      side: const BorderSide(color: TColors.primary)
                  ),
                  onPressed: () => Get.to(() => const PoCompletedScreen()),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(TTexts.markArrival),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}