import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../data/api/register_driver_1.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../vehicle_information/vehicle_selection.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _licenceController = TextEditingController();
  DateTime? _licenceExpiryDate;

  File? profilePhoto;
  File? drivingLicenceFront;
  File? drivingLicenceBack;
  File? nicFront;
  File? nicBack;
  File? billingProof;
  bool noExpiryDate = false;
  bool isLoading = false;

  // Convert image file to base64 string
  Future<String> imageToBase64(File? imageFile) async {
    if (imageFile == null) return '';
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<String> imageToBase64WithPrefix(File? imageFile) async {
    if (imageFile == null) return '';
    try {
      // Get the file extension
      String filePath = imageFile.path.toLowerCase();
      String mimeType;

      if (filePath.endsWith(".png")) {
        mimeType = "image/png";
      } else if (filePath.endsWith(".jpg") || filePath.endsWith(".jpeg")) {
        mimeType = "image/jpeg";
      } else {
        throw Exception("Unsupported file format. Only PNG and JPEG are supported.");
      }

      // Convert the file to Base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepend the MIME type prefix
      return "data:$mimeType;base64,$base64Image";
    } catch (e) {
      print("Error converting image to Base64 with prefix: $e");
      return '';
    }
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    if (noExpiryDate) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _licenceExpiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _licenceExpiryDate) {
      setState(() {
        _licenceExpiryDate = picked;
      });
    }
  }

  // Submit data to API
  Future<void> _submitData() async {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Convert all images to base64
      final Map<String, dynamic> documentData = {
        'profile_photo': await imageToBase64WithPrefix(profilePhoto),
        'driving_licence_front': await imageToBase64WithPrefix(drivingLicenceFront),
        'driving_licence_back': await imageToBase64WithPrefix(drivingLicenceBack),
        'nic_front': await imageToBase64WithPrefix(nicFront),
        'nic_back': await imageToBase64WithPrefix(nicBack),
        'billing_proof': await imageToBase64WithPrefix(billingProof),
        'licence_number': _licenceController.text,
        'has_expiry_date': !noExpiryDate,
      };

      // Add expiry date only if noExpiryDate is false
      if (!noExpiryDate && _licenceExpiryDate != null) {
        documentData['licence_expiry_date'] = _licenceExpiryDate!.toIso8601String();
      }

      final driverId = await StorageService.getDriverId();
      if (driverId == null) throw Exception('Driver ID is null');

      // Make API call to update driver data
      final response = await registerDriver1(
        driverId: driverId,
        documentData: documentData
      );

      if (response.statusCode == 200) {
        Get.to(() => const VehicleSelectionScreen());
      } else {
        throw Exception('Failed to submit documents');
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _validateInputs() {
    if (profilePhoto == null ||
        drivingLicenceFront == null ||
        drivingLicenceBack == null ||
        nicFront == null ||
        nicBack == null ||
        billingProof == null ||
        _licenceController.text.isEmpty ||
        (!noExpiryDate && _licenceExpiryDate == null)) {
      return false;
    }
    return true;
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          switch (type) {
            case 'profile':
              profilePhoto = File(image.path);
              break;
            case 'licenceFront':
              drivingLicenceFront = File(image.path);
              break;
            case 'licenceBack':
              drivingLicenceBack = File(image.path);
              break;
            case 'nicFront':
              nicFront = File(image.path);
              break;
            case 'nicBack':
              nicBack = File(image.path);
              break;
            case 'billing':
              billingProof = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
      // Handle any errors here
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerModal(String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, type);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, type);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerContainer(String label, File? imageFile, String type) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _showImagePickerModal(type),
        child: Row(
          children: [
            if (imageFile == null) ...[
              const Icon(Icons.add_a_photo),
              const SizedBox(width: 10),
              Text(label),
            ] else ...[
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        imageFile,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("Image selected"),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showImagePickerModal(type),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TProgressBar(value: 0.2),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Center(
                    child: Text(
                      'Personal Document Upload',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Profile Photo Card
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
                          Text('Profile Photo',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "Profile Photo", profilePhoto, 'profile'),
                        ],
                      ),
                    ),
                  ),

                  // Updated Driving License Card
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
                          Text('Driving Licence',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "Front Side", drivingLicenceFront, 'licenceFront'),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          _buildImagePickerContainer(
                              "Rear Side", drivingLicenceBack, 'licenceBack'),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          TextFormField(
                            controller: _licenceController,
                            decoration: const InputDecoration(
                              labelText: 'Driving Licence No',
                              prefixIcon: Icon(Icons.credit_card),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          if (!noExpiryDate) ...[
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Licence Expiry Date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _licenceExpiryDate == null
                                      ? 'Select Date'
                                      : '${_licenceExpiryDate!.day}/${_licenceExpiryDate!.month}/${_licenceExpiryDate!.year}',
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          CheckboxListTile(
                            title: const Text("My license does not have an expiry date"),
                            value: noExpiryDate,
                            onChanged: (bool? value) {
                              setState(() {
                                noExpiryDate = value ?? false;
                                if (noExpiryDate) {
                                  _licenceExpiryDate = null;
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // NIC Card
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
                          Text('National Identity Card',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "NIC - Front Side", nicFront, 'nicFront'),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          _buildImagePickerContainer(
                              "NIC - Rear Side", nicBack, 'nicBack'),
                        ],
                      ),
                    ),
                  ),

                  // Billing Proof Card
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
                          Text('Billing Proof',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "Billing Proof", billingProof, 'billing'),
                        ],
                      ),
                    ),
                  ),

                  // Updated Continue Button
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        side: const BorderSide(color: TColors.primary),
                      ),
                      onPressed: isLoading ? null : _submitData,
                      child: Text(isLoading ? 'Submitting...' : TTexts.tcontinue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _licenceController.dispose();
    super.dispose();
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Documents'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const TProgressBar(value: 0.2),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               Center(
//                 child: Text(
//                   'Personal Document Upload',
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//
//               // Profile Photo Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(TSizes.defaultSpace),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Profile Photo',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//                       _buildImagePickerContainer(
//                           "Profile Photo", profilePhoto, 'profile'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Driving License Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(TSizes.defaultSpace),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Driving Licence',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//                       _buildImagePickerContainer(
//                           "Front Side", drivingLicenceFront, 'licenceFront'),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//                       _buildImagePickerContainer(
//                           "Rear Side", drivingLicenceBack, 'licenceBack'),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Driving Licence No',
//                           prefixIcon: Icon(Icons.credit_card),
//                         ),
//                       ),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//                       InputDatePickerFormField(
//                         fieldLabelText: 'Licence Expiry Date',
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(1900),
//                         lastDate: DateTime(2100),
//                         acceptEmptyDate: !noExpiryDate,
//                       ),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//                       CheckboxListTile(
//                         title: const Text("My license does not have an expiry date"),
//                         value: noExpiryDate,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             noExpiryDate = value ?? false;
//                           });
//                         },
//                         controlAffinity: ListTileControlAffinity.leading,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // NIC Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(TSizes.defaultSpace),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('National Identity Card',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//                       _buildImagePickerContainer(
//                           "NIC - Front Side", nicFront, 'nicFront'),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//                       _buildImagePickerContainer(
//                           "NIC - Rear Side", nicBack, 'nicBack'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Billing Proof Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(TSizes.defaultSpace),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Billing Proof',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//                       _buildImagePickerContainer(
//                           "Billing Proof", billingProof, 'billing'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Continue Button
//               const SizedBox(height: TSizes.spaceBtwItems),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: TColors.primary,
//                     side: const BorderSide(color: TColors.primary),
//                   ),
//                   onPressed: () => Get.to(() => const VehicleSelectionScreen()),
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