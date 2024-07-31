import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/vehicle_information/vehicle_documents.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../personal_information/widgets/progress_bar.dart';

class VehicleRegistrationScreen extends StatelessWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // List of image paths
    final List<String> vehicleImages = [
      TImages.truckFront,
      TImages.truckRear,
      TImages.truckSide1,
      TImages.truckSide2,
      TImages.truckTrailer,
    ];

    // List of labels
    final List<String> vehicleLabels = [
      'Front Side',
      'Rear Side',
      'Side 1',
      'Side 2',
      'Trailer',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
              const TProgressBar(value: 0.5),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Text(
                  'Vehicle Registration',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Vehicle Information
              Card(
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

                      /// Vehicle Information
                      Text('Vehicle Information',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      Form(
                        child: Column(
                          children: [

                            /// Licence Plate No
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: 'Licence Plate No', prefixIcon: Icon(Icons.credit_card)),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            /// Make
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: 'Make', prefixIcon: Icon(Icons.construction)),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            /// Model
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: 'Model', prefixIcon: Icon(Icons.fire_truck)),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            CheckboxListTile(
                                title: const Text('My vehicle is refrigerated'),
                                value: true,
                                onChanged: (value) {}
                            ),
                            CheckboxListTile(
                                title: const Text('My vehicle has a crane'),
                                value: false,
                                onChanged: (value) {}
                            ),

                            /// Year of Manufacture
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: 'Year of Manufacture', prefixIcon: Icon(Icons.calendar_month)),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            /// Vehicle Color
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: 'Vehicle Color', prefixIcon: Icon(Icons.color_lens)),
                            ),
                            // const SizedBox(height: TSizes.spaceBtwInputFields),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Vehicle Photos
              Card(
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

                      /// Vehicle Photos
                      Text('Vehicle Pictures',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Truck Photos upload UI
                      ListView.builder(
                        shrinkWrap: true, // Ensures the ListView doesn't take up all available space
                        physics: const NeverScrollableScrollPhysics(), // Prevents scrolling inside the SingleChildScrollView
                        itemCount: vehicleImages.length, // Number of vehicle boxes
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Get.to(() => {}),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0), // Adds space between items
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.black),
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        vehicleImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.add_a_photo),
                                            const SizedBox(width: 10),
                                            Text(vehicleLabels[index]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// Buttons
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      side: const BorderSide(
                          color: TColors.primary
                      ),
                    ),
                    onPressed: () => Get.to(() => const VehicleDocumentsScreen()),
                    child: const Text(TTexts.tcontinue),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
