import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/vehicle_information/vehicle_registration.dart';
import 'package:freight_hub/utils/constants/image_strings.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../personal_information/widgets/progress_bar.dart';

class VehicleSelectionScreen extends StatelessWidget {
  const VehicleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image paths
    final List<String> vehicleImages = [
      TImages.truckType01,
      TImages.truckType02,
      TImages.truckType03,
      TImages.truckType04,
      TImages.truckType05,
      TImages.truckType06,
    ];

    // List of labels
    final List<String> vehicleLabels = [
      '5 ft',
      '7 ft',
      '10 ft',
      '14 ft',
      '20 ft',
      '25 ft',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Vehicle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
              const TProgressBar(value: 0.4),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Text(
                  'What are you driving?',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Truck types
              SizedBox(
                height: THelperFunction.getHeight(), // You can adjust the height as needed
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: vehicleImages.length, // Number of vehicle boxes
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.to(() => const VehicleRegistrationScreen()),
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('${vehicleLabels[index]} vehicle selected')),
                        // );,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                vehicleImages[index],
                                fit: BoxFit.cover,
                                // height: 50, // Adjust the height and width as needed
                                // width: 50,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                vehicleLabels[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Buttons
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(color: TColors.primary),
                  ),
                  onPressed: () => Get.to(() => const VehicleRegistrationScreen()),
                  child: const Text(TTexts.tcontinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}