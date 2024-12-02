import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/start_trip.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/call_info_row_widget.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/info_row_widget.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapsLauncher {
  // Method to launch Google Maps with a specific location
  static Future<void> openMapForLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude${label != null ? '&query_place_id=$label' : ''}'
    );

    try {
      if (await canLaunchUrl(mapUrl)) {
        await launchUrl(
          mapUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $mapUrl';
      }
    } catch (e) {
      print('Error launching Google Maps: $e');
      // Optionally show an error dialog or snackbar
    }
  }

  // Method to open directions to a specific location
  static Future<void> openDirections({
    required double startLatitude,
    required double startLongitude,
    required double destLatitude,
    required double destLongitude,
  }) async {
    final Uri directionsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destLatitude,$destLongitude'
    );

    try {
      if (await canLaunchUrl(directionsUrl)) {
        await launchUrl(
          directionsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $directionsUrl';
      }
    } catch (e) {
      print('Error launching Google Maps directions: $e');
      // Optionally show an error dialog or snackbar
    }
  }
}

class ArrivedToPickupScreen extends StatelessWidget {
  const ArrivedToPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TTexts.loadUndertaken),
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
                            Text(TTexts.loadInfoTitle),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const TInfoRow(left: 'Pickup Date', right: 'Pickup Time'),
                      const TInfoRow(left: '*****', right: '*****'),
                      const TInfoRow(left: 'Final Drop-off Date', right: 'Final Drop-off Time'),
                      const TInfoRow(left: '*****', right: '*****'),

                      const SizedBox(height: TSizes.spaceBtwItems),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: TSizes.lg / 2, horizontal: TSizes.lg),
                          decoration: const BoxDecoration(
                            color: TColors.info, // Replace with your color
                            // borderRadius: BorderRadius.circular(TSizes.md),
                          ),
                          child: Text(TTexts.arrivalInProgress, style: Theme.of(context).textTheme.titleMedium
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () {
                  // Example usage
                  GoogleMapsLauncher.openMapForLocation(
                    latitude: 37.7749, // Example: San Francisco
                    longitude: -122.4194,
                    label: 'San Francisco', // Optional
                  );
                },
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
                  onPressed: () => Get.off(() => const StartTripScreen()),
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