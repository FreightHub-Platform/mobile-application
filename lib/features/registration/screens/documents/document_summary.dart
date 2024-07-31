import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/documents/thank_you.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../personal_information/widgets/progress_bar.dart';

class DocumentSummaryScreen extends StatelessWidget {
  const DocumentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
              const TProgressBar(value: 1.0),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Text(
                  'Document Summary',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: Text(
                  'Submission status for your provided documents are shown below.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Personal Information Section
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildDocumentItem('Profile Photo', 'Pending Approval'),
              _buildDocumentItem('Driving License', 'Pending Approval'),
              _buildDocumentItem('National Identity Card', 'Pending Approval'),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Vehicle Details Section
              Text(
                'Vehicle Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildDocumentItem('Vehicle Revenue Licence', 'Pending Approval'),
              _buildDocumentItem('Vehicle Insurance', 'Pending Approval'),
              _buildDocumentItem('Vehicle Registration', 'Pending Approval'),

              /// Buttons
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(color: TColors.primary),
                  ),
                  onPressed: () => Get.to(() => const ThankYouScreen()),
                  child: const Text('Finish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String title, String status) {
    return ListTile(
      title: Text(title),
      subtitle: Text(status),
      leading: const Icon(Icons.access_time),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}