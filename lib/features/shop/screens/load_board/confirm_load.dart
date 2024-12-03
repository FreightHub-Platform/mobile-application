import 'package:flutter/material.dart';
import 'package:freight_hub/data/api/update_route_status.dart';
import 'package:freight_hub/features/shop/screens/load_board/load_board.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';
import 'package:freight_hub/navigation_menu.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import './widgets/route_controller.dart';  // Import the RouteController

class ConfirmLoadDialog extends StatelessWidget {
  final RouteModel route;  // Add this to pass the specific route

  const ConfirmLoadDialog({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final RouteController routeController = Get.find();  // Get the route controller instance

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            Text(
                TTexts.confirmLoadTitle,
                style: Theme.of(context).textTheme.headlineMedium
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Message
            Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
                child: Text(
                  TTexts.confirmLoadSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                )
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        side: const BorderSide(color: TColors.primary),
                      ),
                      onPressed: () async {
                        try {
                          // Call API to update route status to 'confirmed'
                          // await routeController.updateRouteStatus(
                          //     route.id,
                          //     'confirmed'
                          // );
                          final int? driverId = await StorageService.getDriverId();
                          if (driverId == null) {
                            throw Exception('Driver ID is null');
                          }

                          final response = await confirmRoute(driverId: driverId, routeId: route.routeId, status: "accepted");
                          if (response.statusCode == 200) {
                            // Close the dialog
                            Get.back();

                            // Navigate to LoadBoardScreen and switch to Confirmed tab
                            Get.offAll(() => const NavigationMenu(),
                                arguments: 1  // Pass index 1 to switch to Confirmed tab
                            );
                          }

                        } catch (e) {
                          // Handle any errors
                          Get.snackbar(
                              'Error',
                              'Failed to confirm load: ${e.toString()}',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white
                          );
                        }
                      },
                      child: const Text(TTexts.confirmLoadTitle)
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.black,
                        side: const BorderSide(color: TColors.black),
                      ),
                      onPressed: () => Get.back(),  // Simply close the dialog
                      child: const Text(TTexts.cancel)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:freight_hub/features/shop/screens/load_board/load_board.dart';
// import 'package:freight_hub/utils/constants/sizes.dart';
// import 'package:get/get.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/texts.dart';
//
// class ConfirmLoadScreen extends StatelessWidget {
//   const ConfirmLoadScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text(TTexts.loadBoardTitle)),
//       body: Center(
//         child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(TSizes.md),
//             ),
//           elevation: 5,
//           color: TColors.white,
//           margin: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Padding(
//             padding: const EdgeInsets.all(TSizes.defaultSpace),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 /// Title
//                 Text(TTexts.confirmLoadTitle, style: Theme.of(context).textTheme.headlineMedium),
//                 const SizedBox(height: TSizes.spaceBtwSections),
//                 /// Message
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
//                   child: Text(TTexts.confirmLoadSubTitle, style: Theme.of(context).textTheme.labelMedium)
//                 ),
//                 const SizedBox(height: TSizes.spaceBtwItems),
//                 /// Buttons
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: TColors.primary,
//                         side: const BorderSide(
//                             color: TColors.primary
//                         ),
//                       ),
//                       onPressed: (){},
//                       child: const Text(TTexts.confirmLoadTitle)
//                   ),
//                 ),
//                 const SizedBox(height: TSizes.spaceBtwItems),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: TColors.black,
//                         side: const BorderSide(
//                             color: TColors.black
//                         ),
//                       ),
//                       onPressed: () => Get.off(() => const LoadBoardScreen()),
//                       child: const Text(TTexts.cancel)
//                   ),
//                 )
//
//               ],
//             ),
//           ),
//         ),
//
//       ),
//     );
//   }
// }
