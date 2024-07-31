import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../vehicle_information/vehicle_selection.dart';

class UploadDocumentsScreen extends StatelessWidget {
  const UploadDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const SizedBox(height: TSizes.spaceBtwItems), // To adjust for status bar space
              const TProgressBar(value: 0.2),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(child: Text('Personal Document Upload', style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Profile Photo card
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
                            Text("Profile Photo"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Driving Licence Card
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

                      Text('Driving Licence', style: Theme.of(context).textTheme.labelMedium),
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
                            Text("Front Side"),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields,),

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
                            Text("Rear Side"),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields,),

                      /// Driving Licence No
                      TextFormField(
                        expands: false,
                        decoration: const InputDecoration(
                            labelText: 'Driving Licence No', prefixIcon: Icon(Icons.credit_card)),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Driving Licence Expire Date
                      InputDatePickerFormField(
                          fieldLabelText: 'Licence Expiry Date',
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields,),
                      CheckboxListTile(
                        title: const Text("My license does not have an expiry date"),
                        value: false,
                        onChanged: (newValue) {},
                        controlAffinity: ListTileControlAffinity.leading,  // Aligns checkbox to the left
                      ),
                    ],
                  ),
                ),
              ),

              /// NIC
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
                            Text("NIC - Front Side"),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields,),
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
                            Text("NIC - Rear Side"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Billing Proof
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
                            Text("Billing Proof"),
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
                    onPressed: () => Get.to(() => const VehicleSelectionScreen()),
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


// class UploadDocumentsScreen extends StatefulWidget {
//   const UploadDocumentsScreen({super.key});
//
//   @override
//   _UploadDocumentsScreenState createState() => _UploadDocumentsScreenState();
// }
//
// class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
//   final _licenseExpiryDateController = TextEditingController();
//
//   @override
//   void dispose() {
//     _licenseExpiryDateController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _licenseExpiryDateController.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Documents'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               buildDocumentSection('Profile Photo', 'Profile Photo'),
//               buildDocumentSection('Driving License', 'Front Side', 'Rear Side'),
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Driving License No:',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text('Expiry Date'),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _licenseExpiryDateController,
//                       decoration: const InputDecoration(
//                         hintText: 'DD/MM/YYYY',
//                         border: OutlineInputBorder(),
//                       ),
//                       readOnly: true,
//                       onTap: () => _selectDate(context),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () => _selectDate(context),
//                   ),
//                 ],
//               ),
//               CheckboxListTile(
//                 title: const Text("My license does not have an expiry date"),
//                 value: false,
//                 onChanged: (newValue) {},
//                 controlAffinity: ListTileControlAffinity.leading,  // Aligns checkbox to the left
//               ),
//               buildDocumentSection('National Identity Card', 'NIC - Front Side', 'NIC - Rear Side'),
//               buildDocumentSection('Billing Proof', 'Billing Proof'),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Handle continue button press
//                   },
//                   child: const Text('Continue'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDocumentSection(String title, String field1, [String? field2]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 8),
//           buildUploadField(field1),
//           if (field2 != null) ...[
//             const SizedBox(height: 8),
//             buildUploadField(field2),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget buildUploadField(String label) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.add),
//           const SizedBox(width: 10),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }