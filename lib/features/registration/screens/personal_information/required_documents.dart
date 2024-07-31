import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/personal_information/personal_information.dart';
import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';

class RequiredDocuments extends StatelessWidget {
  const RequiredDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TTexts.registration),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
              const TProgressBar(value: 0.0),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Text(
                  TTexts.createAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(TSizes.spaceBtwItems / 2),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TTexts.requiredDocument,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: TSizes.sm),
                    Text(TTexts.documentRevenueLicence),
                    Text(TTexts.documentDrivingLicence),
                    Text(TTexts.documentInsuranceCert),
                    Text(TTexts.documentVehiclePhotos),
                    Text(TTexts.documentDriverPhoto),
                    Text(TTexts.documentNic),
                    Text(TTexts.documentBillingProof),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: TColors.white, backgroundColor: TColors.primary, // Text color
                      side: const BorderSide(color: TColors.primary), // Border color
                    ),
                    onPressed: () => Get.to(() => const PersonalInformation()),
                    child: const Text(TTexts.okay),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
