import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';

class TLoadBoardCard extends StatelessWidget {
  final RouteModel route;
  final VoidCallback? onTap;

  const TLoadBoardCard({
    super.key,
    required this.route,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('${route.pickupPoint} - ${route.dropOff}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consignor: ${route.consignerName}'),
            Text('Goods: ${route.itemTypes.join(", ")}'),
            Text('Distance: ${route.routeDistance} km'),
            Text('Estimated Profit: Rs. ${route.estdProfit}'),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../utils/constants/colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../../../utils/constants/texts.dart';
// import '../confirm_load.dart';
// import '../load_information.dart';
// import 'load_board_info_field_widget.dart';
//
// class TLoadBoardCard extends StatelessWidget {
//   const TLoadBoardCard({
//     super.key,
//     required this.cardTitle,
//     required this.consignor,
//     required this.goodType,
//     required this.totalDistance,
//     required this.estimatedProfit,
//   });
//
//   final String cardTitle;
//   final String consignor;
//   final String goodType;
//   final String totalDistance;
//   final String estimatedProfit;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(TSizes.sm),
//       ),
//       elevation: 5,
//       color: TColors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Load Title
//             Center(
//               child: Text(cardTitle,
//                   style: Theme.of(context).textTheme.headlineSmall),
//             ),
//             const SizedBox(height: TSizes.spaceBtwItems),
//
//             /// Load Information
//             Text(TTexts.loadInfoTitle,
//                 style: Theme.of(context).textTheme.labelMedium),
//             const SizedBox(height: TSizes.spaceBtwItems),
//
//             TLoadInfoField(title: TTexts.loadInfoConsignor, value: consignor),
//             TLoadInfoField(title: TTexts.loadInfoGoodsType, value: goodType),
//             TLoadInfoField(title: TTexts.loadInfoTotalDistance, value: totalDistance),
//             TLoadInfoField( title: TTexts.loadInfoEstimatedProfit, value: estimatedProfit),
//             const SizedBox(height: TSizes.spaceBtwItems),
//
//             /// Buttons
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: TColors.primary,
//                 padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
//               ),
//               onPressed: () => Get.to(() => const ConfirmLoadScreen()),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(TTexts.bookLoadNow),
//                 ],
//               ),
//             ),
//             const SizedBox(height: TSizes.sm),
//             TextButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
//               ),
//               onPressed: () => Get.to(() => const LoadInformationScreen()),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(TTexts.moreInfo),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }