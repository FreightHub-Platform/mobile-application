import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_info_card_widget.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';

class LoadInformationScreen extends StatelessWidget {
  const LoadInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.loadBoardTitle)),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TLoadBoardInfoCard(
                title: "Biyagama - Katunayake",
                consignor: "*****",
                consignee: "*****",
                pickupDate: "*****",
                pickupTime: "*****",
                dropOffDate: "*****",
                dropOffTime: "*****",
                goodType: "*****",
                grossWeight: "*****",
                totalDistance: "*****",
                estFuelCost: "*****",
                estimatedProfit: "*****",
                profitPerKm: "*****",
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: ,
    );
  }
}
