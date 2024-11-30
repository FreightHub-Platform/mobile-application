import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/vehicle_information/vehicle_registration.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../personal_information/widgets/progress_bar.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int? selectedVehicleIndex;

  final List<Map<String, dynamic>> vehicleTypes = [
    {
      'length': '5 ft',
      'icon': Icons.local_shipping,
      'name': 'Mini Truck',
      'capacity': 'Up to 500 kg',
      'description': 'Best for small moves and deliveries',
    },
    {
      'length': '7 ft',
      'icon': Icons.local_shipping,
      'name': 'Small Truck',
      'capacity': 'Up to 1000 kg',
      'description': 'Ideal for home furniture and appliances',
    },
    {
      'length': '10 ft',
      'icon': Icons.local_shipping,
      'name': 'Medium Truck',
      'capacity': 'Up to 2000 kg',
      'description': 'Perfect for office relocations',
    },
    {
      'length': '14 ft',
      'icon': Icons.local_shipping,
      'name': 'Large Truck',
      'capacity': 'Up to 3500 kg',
      'description': 'Suitable for commercial goods',
    },
    {
      'length': '20 ft',
      'icon': Icons.local_shipping,
      'name': 'Extra Large Truck',
      'capacity': 'Up to 5000 kg',
      'description': 'For heavy machinery and bulk items',
    },
    {
      'length': '25 ft',
      'icon': Icons.local_shipping,
      'name': 'Container Truck',
      'capacity': 'Up to 7500 kg',
      'description': 'Ideal for long-distance heavy cargo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              const TProgressBar(value: 0.4),
              const SizedBox(height: TSizes.spaceBtwSections),

              Center(
                child: Column(
                  children: [
                    Text(
                      'What are you driving?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select the type of vehicle you operate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vehicleTypes.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicleTypes[index];
                  final isSelected = selectedVehicleIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedVehicleIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? TColors.primary.withOpacity(0.1) : isDark ? Colors.grey[900] : Colors.grey[100],
                          border: Border.all(
                            color: isSelected ? TColors.primary : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? TColors.primary : (isDark ? Colors.grey[800] : Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  vehicle['icon'],
                                  size: 24,
                                  color: isSelected ? Colors.white : TColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          vehicle['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            vehicle['length'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark ? Colors.white70 : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vehicle['capacity'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vehicle['description'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.grey[500] : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio(
                                value: index,
                                groupValue: selectedVehicleIndex,
                                onChanged: (value) {
                                  setState(() {
                                    selectedVehicleIndex = value as int;
                                  });
                                },
                                activeColor: TColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(color: TColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: selectedVehicleIndex != null
                      ? () => Get.to(() => const VehicleRegistrationScreen())
                      : null,
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
// import 'package:flutter/material.dart';
// import 'package:freight_hub/features/registration/screens/vehicle_information/vehicle_registration.dart';
// import 'package:freight_hub/utils/constants/image_strings.dart';
// import 'package:freight_hub/utils/constants/sizes.dart';
// import 'package:freight_hub/utils/helpers/helper_functions.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/texts.dart';
// import '../personal_information/widgets/progress_bar.dart';
//
// class VehicleSelectionScreen extends StatelessWidget {
//   const VehicleSelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // List of image paths
//     final List<String> vehicleImages = [
//       TImages.truckType01,
//       TImages.truckType02,
//       TImages.truckType03,
//       TImages.truckType04,
//       TImages.truckType05,
//       TImages.truckType06,
//     ];
//
//     // List of labels
//     final List<String> vehicleLabels = [
//       '5 ft',
//       '7 ft',
//       '10 ft',
//       '14 ft',
//       '20 ft',
//       '25 ft',
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Vehicle'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Header
//               const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
//               const TProgressBar(value: 0.4),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               Center(
//                 child: Text(
//                   'What are you driving?',
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//
//               /// Truck types
//               SizedBox(
//                 height: THelperFunction.getHeight(), // You can adjust the height as needed
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                   ),
//                   itemCount: vehicleImages.length, // Number of vehicle boxes
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => Get.to(() => const VehicleRegistrationScreen()),
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   SnackBar(content: Text('${vehicleLabels[index]} vehicle selected')),
//                         // );,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 vehicleImages[index],
//                                 fit: BoxFit.cover,
//                                 // height: 50, // Adjust the height and width as needed
//                                 // width: 50,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 vehicleLabels[index],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               /// Buttons
//               const SizedBox(height: TSizes.spaceBtwItems),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: TColors.primary,
//                     side: const BorderSide(color: TColors.primary),
//                   ),
//                   onPressed: () => Get.to(() => const VehicleRegistrationScreen()),
//                   child: const Text(TTexts.tcontinue),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }