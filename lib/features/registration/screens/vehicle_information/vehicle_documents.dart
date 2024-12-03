import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freight_hub/data/api/register_vehicle_1.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../../../data/api/register_driver_1.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../documents/document_summary.dart';
import '../personal_information/widgets/progress_bar.dart';

class VehicleDocumentsScreen extends StatefulWidget {
  const VehicleDocumentsScreen({super.key});

  @override
  State<VehicleDocumentsScreen> createState() => _VehicleDocumentsScreenState();
}

class _VehicleDocumentsScreenState extends State<VehicleDocumentsScreen> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // Document files
  File? vehicleRevenueLicence;
  File? vehicleInsurance;
  File? vehicleRegistrationDoc;

  // Expiry dates
  DateTime? revenueLicenceExpiryDate;
  DateTime? insuranceExpiryDate;

  // Error messages
  String? revenueLicenceError;
  String? revenueLicenceDateError;
  String? insuranceError;
  String? insuranceDateError;
  String? registrationError;

  // Convert image file to base64 string with MIME type prefix
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
  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Select Expiry Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (picked != null) {
      setState(() {
        if (type == 'revenue') {
          revenueLicenceExpiryDate = picked;
          revenueLicenceDateError = null;
        } else if (type == 'insurance') {
          insuranceExpiryDate = picked;
          insuranceDateError = null;
        }
      });
    }
  }

  // Pick image method
  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          switch (type) {
            case 'revenue':
              vehicleRevenueLicence = File(image.path);
              revenueLicenceError = null;
              break;
            case 'insurance':
              vehicleInsurance = File(image.path);
              insuranceError = null;
              break;
            case 'registration':
              vehicleRegistrationDoc = File(image.path);
              registrationError = null;
              break;
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Show image picker modal
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

  // Build image picker container
  Widget _buildImagePickerContainer(String label, File? imageFile, String type, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.black,
            ),
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
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // Validate inputs
  bool _validateInputs() {
    bool isValid = true;

    // Validate Revenue Licence
    if (vehicleRevenueLicence == null) {
      setState(() {
        revenueLicenceError = 'Please upload Vehicle Revenue Licence';
      });
      isValid = false;
    }

    // Validate Revenue Licence Expiry Date
    if (revenueLicenceExpiryDate == null) {
      setState(() {
        revenueLicenceDateError = 'Please select Revenue Licence Expiry Date';
      });
      isValid = false;
    }

    // Validate Vehicle Insurance
    if (vehicleInsurance == null) {
      setState(() {
        insuranceError = 'Please upload Vehicle Insurance Document';
      });
      isValid = false;
    }

    // Validate Insurance Expiry Date
    if (insuranceExpiryDate == null) {
      setState(() {
        insuranceDateError = 'Please select Insurance Expiry Date';
      });
      isValid = false;
    }

    // Validate Vehicle Registration Document
    if (vehicleRegistrationDoc == null) {
      setState(() {
        registrationError = 'Please upload Vehicle Registration Document';
      });
      isValid = false;
    }

    return isValid;
  }

  // Submit data
  Future<void> _submitData() async {
    // Validate all inputs first
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare document data
      final Map<String, dynamic> vehicleDocumentData = {
        'vehicle_revenue_licence': await imageToBase64WithPrefix(vehicleRevenueLicence),
        'vehicle_insurance': await imageToBase64WithPrefix(vehicleInsurance),
        'vehicle_registration_document': await imageToBase64WithPrefix(vehicleRegistrationDoc),
        'revenue_licence_expiry_date': revenueLicenceExpiryDate!.toIso8601String(),
        'insurance_expiry_date': insuranceExpiryDate!.toIso8601String(),
      };

      // Get driver ID
      final driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      // Get driver ID
      var vehicleId = await StorageService.getVehicleId();
      if (vehicleId == null) {
        // throw Exception('Driver ID is null');
        vehicleId = 1;
      }

      // Make API call to update Vehicle data
      final response = await registerVehicle1(
          driverId: driverId,
          vehicleId: vehicleId,
          vehicleDocumentData: vehicleDocumentData
      );

      print(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        Get.to(() => const DocumentSummaryScreen());
      } else {
        throw Exception('Failed to submit vehicle documents');
      }
      // Get.to(() => const DocumentSummaryScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Documents'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TProgressBar(value: 0.75),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Center(
                    child: Text(
                      'Vehicle Documents Upload',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Vehicle Revenue Licence Card
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
                          Text('Vehicle Revenue Licence',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "Vehicle Revenue Licence", vehicleRevenueLicence, 'revenue', revenueLicenceError),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          InkWell(
                            onTap: () => _selectDate(context, 'revenue'),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Revenue Licence Expiry Date',
                                prefixIcon: const Icon(Icons.calendar_today),
                                errorText: revenueLicenceDateError,
                              ),
                              child: Text(
                                revenueLicenceExpiryDate == null
                                    ? 'Select Date'
                                    : '${revenueLicenceExpiryDate!.day}/${revenueLicenceExpiryDate!.month}/${revenueLicenceExpiryDate!.year}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Vehicle Insurance Card
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
                          Text('Vehicle Insurance',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "Vehicle Insurance", vehicleInsurance, 'insurance', insuranceError),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          InkWell(
                            onTap: () => _selectDate(context, 'insurance'),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Insurance Expiry Date',
                                prefixIcon: const Icon(Icons.calendar_today),
                                errorText: insuranceDateError,
                              ),
                              child: Text(
                                insuranceExpiryDate == null
                                    ? 'Select Date'
                                    : '${insuranceExpiryDate!.day}/${insuranceExpiryDate!.month}/${insuranceExpiryDate!.year}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Vehicle Registration Document Card
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
                          Text('Vehicle Registrations Document',
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildImagePickerContainer(
                              "Vehicle Registrations Document", vehicleRegistrationDoc, 'registration', registrationError),
                        ],
                      ),
                    ),
                  ),

                  // Continue Button
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
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:freight_hub/utils/constants/sizes.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
//
// import '../../../../data/api/register_driver_1.dart';
// import '../../../../data/services/storage_service.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/texts.dart';
// import '../documents/document_summary.dart';
// import '../personal_information/widgets/progress_bar.dart';
//
// class VehicleDocumentsScreen extends StatefulWidget {
//   const VehicleDocumentsScreen({super.key});
//
//   @override
//   State<VehicleDocumentsScreen> createState() => _VehicleDocumentsScreenState();
// }
//
// class _VehicleDocumentsScreenState extends State<VehicleDocumentsScreen> {
//   final ImagePicker _picker = ImagePicker();
//   bool isLoading = false;
//
//   // Document files
//   File? vehicleRevenueLicence;
//   File? vehicleInsurance;
//   File? vehicleRegistrationDoc;
//
//   // Expiry dates
//   DateTime? revenueLicenceExpiryDate;
//   DateTime? insuranceExpiryDate;
//
//   // Convert image file to base64 string with MIME type prefix
//   Future<String> imageToBase64WithPrefix(File? imageFile) async {
//     if (imageFile == null) return '';
//     try {
//       // Get the file extension
//       String filePath = imageFile.path.toLowerCase();
//       String mimeType;
//
//       if (filePath.endsWith(".png")) {
//         mimeType = "image/png";
//       } else if (filePath.endsWith(".jpg") || filePath.endsWith(".jpeg")) {
//         mimeType = "image/jpeg";
//       } else {
//         throw Exception("Unsupported file format. Only PNG and JPEG are supported.");
//       }
//
//       // Convert the file to Base64
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);
//
//       // Prepend the MIME type prefix
//       return "data:$mimeType;base64,$base64Image";
//     } catch (e) {
//       print("Error converting image to Base64 with prefix: $e");
//       return '';
//     }
//   }
//
//   // Show date picker
//   Future<void> _selectDate(BuildContext context, String type) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (type == 'revenue') {
//           revenueLicenceExpiryDate = picked;
//         } else if (type == 'insurance') {
//           insuranceExpiryDate = picked;
//         }
//       });
//     }
//   }
//
//   // Pick image method
//   Future<void> _pickImage(ImageSource source, String type) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           switch (type) {
//             case 'revenue':
//               vehicleRevenueLicence = File(image.path);
//               break;
//             case 'insurance':
//               vehicleInsurance = File(image.path);
//               break;
//             case 'registration':
//               vehicleRegistrationDoc = File(image.path);
//               break;
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//     }
//   }
//
//   // Show image picker modal
//   void _showImagePickerModal(String type) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Take a photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera, type);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery, type);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Build image picker container
//   Widget _buildImagePickerContainer(String label, File? imageFile, String type) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         onTap: () => _showImagePickerModal(type),
//         child: Row(
//           children: [
//             if (imageFile == null) ...[
//               const Icon(Icons.add_a_photo),
//               const SizedBox(width: 10),
//               Text(label),
//             ] else ...[
//               Expanded(
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         imageFile,
//                         height: 50,
//                         width: 50,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text("Image selected"),
//                     const Spacer(),
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _showImagePickerModal(type),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Validate inputs
//   bool _validateInputs() {
//     if (vehicleRevenueLicence == null ||
//         revenueLicenceExpiryDate == null ||
//         vehicleInsurance == null ||
//         insuranceExpiryDate == null ||
//         vehicleRegistrationDoc == null) {
//       return false;
//     }
//     return true;
//   }
//
//   // Submit data
//   Future<void> _submitData() async {
//     if (!_validateInputs()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all required fields')),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       // Prepare document data
//       final Map<String, dynamic> vehicleDocumentData = {
//         'vehicle_revenue_licence': await imageToBase64WithPrefix(vehicleRevenueLicence),
//         'vehicle_insurance': await imageToBase64WithPrefix(vehicleInsurance),
//         'vehicle_registration_document': await imageToBase64WithPrefix(vehicleRegistrationDoc),
//         'revenue_licence_expiry_date': revenueLicenceExpiryDate!.toIso8601String(),
//         'insurance_expiry_date': insuranceExpiryDate!.toIso8601String(),
//       };
//
//       // Get driver ID
//       final driverId = await StorageService.getDriverId();
//       if (driverId == null) throw Exception('Driver ID is null');
//
//       // Make API call to update driver data
//       final response = await registerDriver1(
//           driverId: driverId,
//           documentData: vehicleDocumentData
//       );
//
//       if (response.statusCode == 200) {
//         Get.to(() => const DocumentSummaryScreen());
//       } else {
//         throw Exception('Failed to submit vehicle documents');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vehicle Documents'),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(TSizes.defaultSpace),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const TProgressBar(value: 0.75),
//                   const SizedBox(height: TSizes.spaceBtwSections),
//                   Center(
//                     child: Text(
//                       'Vehicle Documents Upload',
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//                   ),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//
//                   // Vehicle Revenue Licence Card
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     elevation: 5,
//                     color: TColors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(TSizes.defaultSpace),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Vehicle Revenue Licence',
//                               style: Theme.of(context).textTheme.labelMedium),
//                           const SizedBox(height: TSizes.spaceBtwItems),
//                           _buildImagePickerContainer(
//                               "Vehicle Revenue Licence", vehicleRevenueLicence, 'revenue'),
//                           const SizedBox(height: TSizes.spaceBtwInputFields),
//                           InkWell(
//                             onTap: () => _selectDate(context, 'revenue'),
//                             child: InputDecorator(
//                               decoration: const InputDecoration(
//                                 labelText: 'Revenue Licence Expiry Date',
//                                 prefixIcon: Icon(Icons.calendar_today),
//                               ),
//                               child: Text(
//                                 revenueLicenceExpiryDate == null
//                                     ? 'Select Date'
//                                     : '${revenueLicenceExpiryDate!.day}/${revenueLicenceExpiryDate!.month}/${revenueLicenceExpiryDate!.year}',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Vehicle Insurance Card
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     elevation: 5,
//                     color: TColors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(TSizes.defaultSpace),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Vehicle Insurance',
//                               style: Theme.of(context).textTheme.labelMedium),
//                           const SizedBox(height: TSizes.spaceBtwItems),
//                           _buildImagePickerContainer(
//                               "Vehicle Insurance", vehicleInsurance, 'insurance'),
//                           const SizedBox(height: TSizes.spaceBtwInputFields),
//                           InkWell(
//                             onTap: () => _selectDate(context, 'insurance'),
//                             child: InputDecorator(
//                               decoration: const InputDecoration(
//                                 labelText: 'Insurance Expiry Date',
//                                 prefixIcon: Icon(Icons.calendar_today),
//                               ),
//                               child: Text(
//                                 insuranceExpiryDate == null
//                                     ? 'Select Date'
//                                     : '${insuranceExpiryDate!.day}/${insuranceExpiryDate!.month}/${insuranceExpiryDate!.year}',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Vehicle Registration Document Card
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     elevation: 5,
//                     color: TColors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(TSizes.defaultSpace),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Vehicle Registrations Document',
//                               style: Theme.of(context).textTheme.labelMedium),
//                           const SizedBox(height: TSizes.spaceBtwItems),
//                           _buildImagePickerContainer(
//                               "Vehicle Registrations Document", vehicleRegistrationDoc, 'registration'),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Continue Button
//                   const SizedBox(height: TSizes.spaceBtwItems),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: TColors.primary,
//                         side: const BorderSide(color: TColors.primary),
//                       ),
//                       onPressed: isLoading ? null : _submitData,
//                       child: Text(isLoading ? 'Submitting...' : TTexts.tcontinue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:freight_hub/utils/constants/sizes.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/texts.dart';
// import '../documents/document_summary.dart';
// import '../personal_information/widgets/progress_bar.dart';
//
// class VehicleDocumentsScreen extends StatelessWidget {
//   const VehicleDocumentsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vehicle Documents'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Header
//               const TProgressBar(value: 0.75),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               Center(
//                 child: Text(
//                   'Vehicle Documents Upload',
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//
//               /// Vehicle Revenue Licence
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
//
//                       /// Vehicle Revenue Licence
//                       Text('Vehicle Revenue Licence',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Row(
//                           children: [
//                             Icon(Icons.add_a_photo),
//                             SizedBox(width: 10),
//                             Text('Vehicle Revenue Licence'),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                       /// Revenue Licence Expire Date
//                       InputDatePickerFormField(
//                           fieldLabelText: 'Expire Date',
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(1900),
//                           lastDate: DateTime(2100)
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Vehicle Insurance
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
//
//                       /// Vehicle Insurance
//                       Text('Vehicle Insurance',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Row(
//                           children: [
//                             Icon(Icons.add_a_photo),
//                             SizedBox(width: 10),
//                             Text('Vehicle Insurance'),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                       /// Insurance Expire Date
//                       InputDatePickerFormField(
//                           fieldLabelText: 'Expire Date',
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(1900),
//                           lastDate: DateTime(2100)
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Vehicle Registrations Document
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
//
//                       /// Vehicle Registrations Document
//                       Text('Vehicle Registrations Document',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Row(
//                           children: [
//                             Icon(Icons.add_a_photo),
//                             SizedBox(width: 10),
//                             Text('Vehicle Registrations Document'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Button
//               const SizedBox(height: TSizes.spaceBtwItems),
//               SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: TColors.primary,
//                       side: const BorderSide(
//                           color: TColors.primary
//                       ),
//                     ),
//                     onPressed: () => Get.to(() => const DocumentSummaryScreen()),
//                     child: const Text(TTexts.tcontinue),
//                   )
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
