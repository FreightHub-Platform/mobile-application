import 'package:flutter/material.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../documents/document_summary.dart';
import '../personal_information/widgets/progress_bar.dart';

class VehicleDocumentsScreen extends StatelessWidget {
  const VehicleDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Documents'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
              const TProgressBar(value: 0.75),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Text(
                  'Vehicle Documents Upload',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Vehicle Revenue Licence
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

                      /// Vehicle Revenue Licence
                      Text('Vehicle Revenue Licence',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_a_photo),
                            SizedBox(width: 10),
                            Text('Vehicle Revenue Licence'),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Revenue Licence Expire Date
                      InputDatePickerFormField(
                          fieldLabelText: 'Expire Date',
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)
                      ),
                    ],
                  ),
                ),
              ),

              /// Vehicle Insurance
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

                      /// Vehicle Insurance
                      Text('Vehicle Insurance',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_a_photo),
                            SizedBox(width: 10),
                            Text('Vehicle Insurance'),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Insurance Expire Date
                      InputDatePickerFormField(
                          fieldLabelText: 'Expire Date',
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)
                      ),
                    ],
                  ),
                ),
              ),

              /// Vehicle Registrations Document
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

                      /// Vehicle Registrations Document
                      Text('Vehicle Registrations Document',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_a_photo),
                            SizedBox(width: 10),
                            Text('Vehicle Registrations Document'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Button
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
                    onPressed: () => Get.to(() => const DocumentSummaryScreen()),
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
