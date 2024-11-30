import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freight_hub/data/services/storage_service.dart';
import 'package:freight_hub/features/registration/screens/personal_information/personal_documents.dart';
import 'package:freight_hub/features/registration/screens/personal_information/personal_information.dart';
import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../data/api/get_driver.dart';
import '../../../../utils/constants/colors.dart';
import '../vehicle_information/vehicle_selection.dart';

class RequiredDocuments extends StatefulWidget {
  const RequiredDocuments({super.key});

  @override
  State<RequiredDocuments> createState() => _RequiredDocumentsState();
}

class _RequiredDocumentsState extends State<RequiredDocuments> {
  bool _isLoading = true;
  Map<String, dynamic>? _driverData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    try {
      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final response = await getDriverSingle(driverId: driverId);
      if (response.statusCode == 200) {
        final data = json.decode(await response.stream.bytesToString());

        setState(() {
          _driverData = data;
          _isLoading = false;
        });

        // condition to check the driver data
        // For example, if the driver has completed registration:
        print("Driver ID: $driverId");
        print("Completion: ${data['data']['driver']['completion']}");
        print(data);
        if (data['data']['driver']['completion'] == 1) {
          // Navigate to another screen
          Get.off(() => const UploadDocumentsScreen());
          return;
        } else if (data['data']['driver']['completion'] == 2) {
          // Navigate to another screen
          Get.off(() => const VehicleSelectionScreen());
          return;
        } // Add more here
      } else {
        throw Exception('Failed to load driver data: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _loadDriverData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      foregroundColor: TColors.white,
                      backgroundColor: TColors.primary,
                      side: const BorderSide(color: TColors.primary),
                    ),
                    onPressed: () => Get.to(() => const PersonalInformation()),
                    child: const Text(TTexts.okay),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TTexts.registration),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _buildContent(),
    );
  }
}