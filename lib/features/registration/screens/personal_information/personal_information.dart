import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freight_hub/features/registration/screens/personal_information/personal_documents.dart';
import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../data/api/get_driver.dart';
import '../../../../data/api/register_driver_0.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String? _error;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nicController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  String? _selectedProvince;

  // List of provinces
  final List<String> _provinces = [
    'Western', 'Central', 'Southern', 'Northern', 'Eastern',
    'North Western', 'North Central', 'Uva', 'Sabaragamuwa',
  ];

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    try {
      setState(() => _isLoading = true);

      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final response = await getDriverSingle(driverId: driverId);
      if (response.statusCode == 200) {
        final data = json.decode(await response.stream.bytesToString());

        // Populate form fields with existing data
        _firstNameController.text = data['data']['fname'] ?? '';
        _lastNameController.text = data['data']['lname'] ?? '';
        _phoneController.text = data['data']['contactNumber'] ?? '';
        _nicController.text = data['data']['nic'] ?? '';
        _streetController.text = data['data']['addressLine1'] ?? '';
        _cityController.text = data['data']['city'] ?? '';
        _zipCodeController.text = data['data']['postalCode'] ?? '';

        setState(() {
          _selectedProvince = data['data']['province'];
          _isLoading = false;
        });
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

  Future<void> _submitDriver() async {
    try {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);

      final driverId = await StorageService.getDriverId();
      if (driverId == null) throw Exception('Driver ID is null');

      // Make API call to update driver data
      final response = await registerDriver0(
        driverId: driverId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        nic: _nicController.text,
        street: _streetController.text,
        city: _cityController.text,
        province: (_selectedProvince) ?? '',
        zipCode: _zipCodeController.text,
      );

      if (response.statusCode == 200) {

        print(json.decode(await response.stream.bytesToString()));

        Get.to(() => const UploadDocumentsScreen());
      } else {
        throw Exception('Failed to update driver: ${response.reasonPhrase}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _nicController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  // Validation Functions
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!value.startsWith('07')) {
      return 'Phone number must start with 07';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? _validateNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIC is required';
    }

    // Pattern 1: 9 digits followed by V/X (case insensitive)
    final pattern1 = RegExp(r'^\d{9}[VvXx]$');

    // Pattern 2: exactly 12 digits
    final pattern2 = RegExp(r'^\d{12}$');

    if (!pattern1.hasMatch(value) && !pattern2.hasMatch(value)) {
      return 'Invalid NIC format';
    }
    return null;
  }

  String? _validateProvince(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a province';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'ZIP code is required';
    }
    if (value.length != 5) {
      return 'ZIP code must be 5 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'ZIP code must contain only digits';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loadDriverData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
              const TProgressBar(value: 0.05),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Text(
                  TTexts.personalInformation,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

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

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            Text(TTexts.personalInformation,
                                style: Theme.of(context).textTheme.labelMedium),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            // First Name and Last Name
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    validator: (value) => _validateRequired(value, 'First name'),
                                    decoration: const InputDecoration(
                                      labelText: TTexts.firstName,
                                      prefixIcon: Icon(Iconsax.user),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: TSizes.spaceBtwInputFields),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    validator: (value) => _validateRequired(value, 'Last name'),
                                    decoration: const InputDecoration(
                                      labelText: TTexts.lastName,
                                      prefixIcon: Icon(Iconsax.user),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            // Phone Number
                            TextFormField(
                              controller: _phoneController,
                              validator: _validatePhone,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                labelText: TTexts.phoneNo,
                                prefixIcon: Icon(Iconsax.call),
                                counterText: '',
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            // NIC
                            TextFormField(
                              controller: _nicController,
                              validator: _validateNIC,
                              decoration: const InputDecoration(
                                labelText: TTexts.personalInfoNic,
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            Text(TTexts.personalInfoAddress,
                                style: Theme.of(context).textTheme.labelMedium),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            // Address
                            TextFormField(
                              controller: _streetController,
                              validator: (value) => _validateRequired(value, 'Street'),
                              decoration: const InputDecoration(
                                labelText: TTexts.personalInfoStreet,
                                prefixIcon: Icon(Icons.streetview),
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            // City
                            TextFormField(
                              controller: _cityController,
                              validator: (value) => _validateRequired(value, 'City'),
                              decoration: const InputDecoration(
                                labelText: TTexts.personalInfoCity,
                                prefixIcon: Icon(Icons.location_city),
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            // Province Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedProvince,
                              decoration: const InputDecoration(
                                labelText: TTexts.personalInfoProvince,
                                prefixIcon: Icon(Icons.add_location),
                              ),
                              validator: _validateProvince,
                              hint: const Text('Select Province'),
                              items: [
                                ..._provinces.map((String province) {
                                  return DropdownMenuItem<String>(
                                    value: province,
                                    child: Text(province),
                                  );
                                }).toList(),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedProvince = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            // Zip Code
                            TextFormField(
                              controller: _zipCodeController,
                              validator: _validateZipCode,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              decoration: const InputDecoration(
                                labelText: TTexts.personalInfoZipCode,
                                prefixIcon: Icon(Icons.numbers),
                                counterText: '',
                              ),
                            )

                            // Province and ZIP Code
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(color: TColors.primary),
                  ),
                  onPressed: _submitDriver,
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
// import 'package:flutter/services.dart';
// import 'package:freight_hub/features/registration/screens/personal_information/personal_documents.dart';
// import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
// import 'package:freight_hub/utils/constants/texts.dart';
// import 'package:get/get.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/sizes.dart';
//
// class PersonalInformation extends StatefulWidget {
//   const PersonalInformation({super.key});
//
//   @override
//   State<PersonalInformation> createState() => _PersonalInformationState();
// }
//
// class _PersonalInformationState extends State<PersonalInformation> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _nicController = TextEditingController();
//   final _streetController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _zipCodeController = TextEditingController();
//
//   String? _selectedProvince;
//
//   // List of provinces
//   final List<String> _provinces = [
//     'Western',
//     'Central',
//     'Southern',
//     'Northern',
//     'Eastern',
//     'North Western',
//     'North Central',
//     'Uva',
//     'Sabaragamuwa',
//   ];
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     _nicController.dispose();
//     _streetController.dispose();
//     _cityController.dispose();
//     _zipCodeController.dispose();
//     super.dispose();
//   }
//
//   // Validation Functions
//   String? _validateRequired(String? value, String fieldName) {
//     if (value == null || value.isEmpty) {
//       return '$fieldName is required';
//     }
//     return null;
//   }
//
//   String? _validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required';
//     }
//     if (!value.startsWith('07')) {
//       return 'Phone number must start with 07';
//     }
//     if (value.length != 10) {
//       return 'Phone number must be 10 digits';
//     }
//     if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//       return 'Phone number must contain only digits';
//     }
//     return null;
//   }
//
//   String? _validateNIC(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'NIC is required';
//     }
//
//     // Pattern 1: 9 digits followed by V/X (case insensitive)
//     final pattern1 = RegExp(r'^\d{9}[VvXx]$');
//
//     // Pattern 2: exactly 12 digits
//     final pattern2 = RegExp(r'^\d{12}$');
//
//     if (!pattern1.hasMatch(value) && !pattern2.hasMatch(value)) {
//       return 'Invalid NIC format';
//     }
//     return null;
//   }
//
//   String? _validateProvince(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please select a province';
//     }
//     return null;
//   }
//
//   String? _validateZipCode(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'ZIP code is required';
//     }
//     if (value.length != 5) {
//       return 'ZIP code must be 5 digits';
//     }
//     if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//       return 'ZIP code must contain only digits';
//     }
//     return null;
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // If validation passes, proceed to next screen
//       Get.to(() => const UploadDocumentsScreen());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(TTexts.registration),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // const SizedBox(height: TSizes.spaceBtwItems),
//               const TProgressBar(value: 0.05),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               Center(
//                 child: Text(
//                   TTexts.personalInformation,
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),
//
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
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//
//                             Text(TTexts.personalInformation,
//                                 style: Theme.of(context).textTheme.labelMedium),
//                             const SizedBox(height: TSizes.spaceBtwItems),
//
//                             // First Name and Last Name
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: TextFormField(
//                                     controller: _firstNameController,
//                                     validator: (value) => _validateRequired(value, 'First name'),
//                                     decoration: const InputDecoration(
//                                       labelText: TTexts.firstName,
//                                       prefixIcon: Icon(Iconsax.user),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: TSizes.spaceBtwInputFields),
//                                 Expanded(
//                                   child: TextFormField(
//                                     controller: _lastNameController,
//                                     validator: (value) => _validateRequired(value, 'Last name'),
//                                     decoration: const InputDecoration(
//                                       labelText: TTexts.lastName,
//                                       prefixIcon: Icon(Iconsax.user),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                             // Phone Number
//                             TextFormField(
//                               controller: _phoneController,
//                               validator: _validatePhone,
//                               keyboardType: TextInputType.phone,
//                               maxLength: 10,
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.phoneNo,
//                                 prefixIcon: Icon(Iconsax.call),
//                                 counterText: '',
//                               ),
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                             // NIC
//                             TextFormField(
//                               controller: _nicController,
//                               validator: _validateNIC,
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.personalInfoNic,
//                                 prefixIcon: Icon(Icons.credit_card),
//                               ),
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                             Text(TTexts.personalInfoAddress,
//                                 style: Theme.of(context).textTheme.labelMedium),
//                             const SizedBox(height: TSizes.spaceBtwItems),
//
//                             // Address
//                             TextFormField(
//                               controller: _streetController,
//                               validator: (value) => _validateRequired(value, 'Street'),
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.personalInfoStreet,
//                                 prefixIcon: Icon(Icons.streetview),
//                               ),
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                             // City
//                             TextFormField(
//                               controller: _cityController,
//                               validator: (value) => _validateRequired(value, 'City'),
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.personalInfoCity,
//                                 prefixIcon: Icon(Icons.location_city),
//                               ),
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                             // Province Dropdown
//                             DropdownButtonFormField<String>(
//                               value: _selectedProvince,
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.personalInfoProvince,
//                                 prefixIcon: Icon(Icons.add_location),
//                               ),
//                               validator: _validateProvince,
//                               hint: const Text('Select Province'),
//                               items: [
//                                 ..._provinces.map((String province) {
//                                   return DropdownMenuItem<String>(
//                                     value: province,
//                                     child: Text(province),
//                                   );
//                                 }).toList(),
//                               ],
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _selectedProvince = newValue;
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//                             // Zip Code
//                             TextFormField(
//                               controller: _zipCodeController,
//                               validator: _validateZipCode,
//                               keyboardType: TextInputType.number,
//                               maxLength: 5,
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.personalInfoZipCode,
//                                 prefixIcon: Icon(Icons.numbers),
//                                 counterText: '',
//                               ),
//                             )
//
//                             // Province and ZIP Code
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: TSizes.spaceBtwItems),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: TColors.primary,
//                     side: const BorderSide(color: TColors.primary),
//                   ),
//                   onPressed: _submitForm,
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
//
// // import 'package:flutter/material.dart';
// // import 'package:freight_hub/features/registration/screens/personal_information/personal_documents.dart';
// // import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
// // import 'package:freight_hub/utils/constants/texts.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:iconsax_flutter/iconsax_flutter.dart';
// //
// // import '../../../../utils/constants/colors.dart';
// // import '../../../../utils/constants/sizes.dart';
// // import '../../../shop/screens/load_board/widgets/load_board_info_field_widget.dart';
// //
// // class PersonalInformation extends StatelessWidget {
// //   const PersonalInformation({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(TTexts.registration),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(TSizes.defaultSpace),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
// //               const TProgressBar(value: 0.05),
// //               const SizedBox(height: TSizes.spaceBtwSections),
// //               Center(
// //                 child: Text(
// //                   TTexts.personalInformation,
// //                   style: Theme.of(context).textTheme.headlineMedium,
// //                 ),
// //               ),
// //               const SizedBox(height: TSizes.spaceBtwItems),
// //
// //               Card(
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(10.0),
// //                 ),
// //                 elevation: 5,
// //                 color: TColors.white,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(TSizes.defaultSpace),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //
// //                       /// Personal Information
// //                       Text(TTexts.personalInformation,
// //                           style: Theme.of(context).textTheme.labelMedium),
// //                       const SizedBox(height: TSizes.spaceBtwItems),
// //
// //                       Form(
// //                         child: Column(
// //                           children: [
// //                             /// First Name and Last Name
// //                             Row(
// //                               children: [
// //                                 Expanded(
// //                                     child: TextFormField(
// //                                       expands: false,
// //                                       decoration: const InputDecoration(
// //                                           labelText: TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
// //                                     )),
// //                                 const SizedBox(width: TSizes.spaceBtwInputFields),
// //                                 Expanded(
// //                                     child: TextFormField(
// //                                       expands: false,
// //                                       decoration: const InputDecoration(
// //                                           labelText: TTexts.lastName, prefixIcon: Icon(Iconsax.user)),
// //                                     ))
// //                               ],
// //                             ),
// //                             const SizedBox(height: TSizes.spaceBtwInputFields),
// //
// //                             /// Phone Number
// //                             TextFormField(
// //                               expands: false,
// //                               decoration: const InputDecoration(
// //                                   labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
// //                             ),
// //                             const SizedBox(height: TSizes.spaceBtwInputFields),
// //
// //                             /// NIC
// //                             TextFormField(
// //                               expands: false,
// //                               decoration: const InputDecoration(
// //                                   labelText: TTexts.personalInfoNic, prefixIcon: Icon(Icons.credit_card)),
// //                             ),
// //                             const SizedBox(height: TSizes.spaceBtwInputFields),
// //
// //                             /// Input Fields
// //                             Text(TTexts.personalInfoAddress, style: Theme.of(context).textTheme.labelMedium),
// //                             const SizedBox(height: TSizes.spaceBtwItems),
// //
// //                             Row(
// //                               children: [
// //                                 Expanded(
// //                                     child: TextFormField(
// //                                       expands: false,
// //                                       decoration: const InputDecoration(
// //                                           labelText: TTexts.personalInfoStreet, prefixIcon: Icon(Icons.streetview)),
// //                                     )),
// //                                 const SizedBox(width: TSizes.spaceBtwInputFields),
// //                                 Expanded(
// //                                     child: TextFormField(
// //                                       expands: false,
// //                                       decoration: const InputDecoration(
// //                                           labelText: TTexts.personalInfoCity, prefixIcon: Icon(Icons.location_city)),
// //                                     ))
// //                               ],
// //                             ),
// //                             const SizedBox(height: TSizes.spaceBtwInputFields),
// //
// //                             Row(
// //                               children: [
// //                                 Expanded(
// //                                     child: TextFormField(
// //                                       expands: false,
// //                                       decoration: const InputDecoration(
// //                                           labelText: TTexts.personalInfoProvince, prefixIcon: Icon(Icons.add_location)),
// //                                     )),
// //                                 const SizedBox(width: TSizes.spaceBtwInputFields),
// //                                 Expanded(
// //                                     child: TextFormField(
// //                                       expands: false,
// //                                       decoration: const InputDecoration(
// //                                           labelText: TTexts.personalInfoZipCode, prefixIcon: Icon(Icons.numbers)),
// //                                     ))
// //                               ],
// //                             ),
// //                             // const SizedBox(height: TSizes.spaceBtwInputFields),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //               // Card(
// //               //   shape: RoundedRectangleBorder(
// //               //     borderRadius: BorderRadius.circular(10.0),
// //               //   ),
// //               //   elevation: 5,
// //               //   color: TColors.white,
// //               //   child: Padding(
// //               //     padding: const EdgeInsets.all(TSizes.defaultSpace),
// //               //     child: Column(
// //               //       crossAxisAlignment: CrossAxisAlignment.start,
// //               //       children: [
// //               //
// //               //         /// Vehicle Ownership
// //               //         Text(TTexts.vehicleOwnership,
// //               //             style: Theme.of(context).textTheme.labelMedium),
// //               //         const SizedBox(height: TSizes.spaceBtwItems),
// //               //
// //               //         RadioListTile(
// //               //             title: const Text('I am an Individual Driver'),
// //               //             value: "value",
// //               //             groupValue: "groupValue",
// //               //             onChanged: (value){}
// //               //         ),
// //               //         RadioListTile(
// //               //             title: const Text('I am a Company Driver'),
// //               //             value: "value",
// //               //             groupValue: "groupValue",
// //               //             onChanged: (value){}
// //               //         ),
// //               //
// //               //         // RadioListTile<String>(
// //               //         //   title: const Text('I am an Individual Driver'),
// //               //         //   value: 'individual',
// //               //         //   groupValue: '',
// //               //         //   onChanged: (value) {}),
// //               //         // ),
// //               //         // RadioListTile<String>(
// //               //         //   title: const Text('I am a Company Driver'),
// //               //         //   value: 'company',
// //               //         //   groupValue: '',
// //               //         //   onChanged: (value) {},
// //               //         // ),
// //               //       ],
// //               //     ),
// //               //   ),
// //               // ),
// //
// //               const SizedBox(height: TSizes.spaceBtwItems),
// //               SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: TColors.primary,
// //                       side: const BorderSide(
// //                           color: TColors.primary
// //                       ),
// //                     ),
// //                     onPressed: () => Get.to(() => const UploadDocumentsScreen()),
// //                     child: const Text(TTexts.tcontinue),
// //                   )
// //               )
// //             ]
// //           ),
// //         )
// //       ),
// //     );
// //   }
// // }
