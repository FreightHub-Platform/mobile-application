import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/load_information.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_card_widget.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_info_field_widget.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/load_undertaken.dart';
import 'package:freight_hub/utils/constants/colors.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:get/get.dart';

class LoadBoardScreen extends StatelessWidget {
  const LoadBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.loadBoardTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // const Spacer(),
              TextButton(
                  onPressed: () => Get.to(() => const LoadUndertakenScreen()),
                  child: const Text(TTexts.loadUndertaken)),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(TTexts.deliveryRequests,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Load Cards
              const TLoadBoardCard(
                cardTitle: "Biyagama - Katunayake",
                consignor: "*****",
                goodType: "*****",
                totalDistance: "*****",
                estimatedProfit: "*****",
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TLoadBoardCard(
                cardTitle: "Biyagama - Katunayake",
                consignor: "*****",
                goodType: "*****",
                totalDistance: "*****",
                estimatedProfit: "*****",
              )
            ],
          ),
        ),
      ),
    );
  }
}
