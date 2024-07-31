import 'package:flutter/material.dart';
import 'package:freight_hub/features/registration/screens/personal_information/personal_documents.dart';
import 'package:freight_hub/features/registration/screens/personal_information/widgets/progress_bar.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../shop/screens/load_board/widgets/load_board_info_field_widget.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

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

                      /// Personal Information
                      Text(TTexts.personalInformation,
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Pre-Submitted details
                      const TLoadInfoField(title: TTexts.firstName, value: "*****"),
                      const TLoadInfoField(title: TTexts.lastName, value: "*****"),
                      const TLoadInfoField(title: TTexts.email, value: "*****@gmail.com"),
                      const TLoadInfoField(title: TTexts.phoneNo, value: "07*-*******"),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      Form(
                        child: Column(
                          children: [
                            /// NIC
                            TextFormField(
                              expands: false,
                              decoration: const InputDecoration(
                                  labelText: TTexts.personalInfoNic, prefixIcon: Icon(Icons.credit_card)),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            /// Input Fields
                            Text(TTexts.personalInfoAddress, style: Theme.of(context).textTheme.labelMedium),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                      expands: false,
                                      decoration: const InputDecoration(
                                          labelText: TTexts.personalInfoStreet, prefixIcon: Icon(Icons.streetview)),
                                    )),
                                const SizedBox(width: TSizes.spaceBtwInputFields),
                                Expanded(
                                    child: TextFormField(
                                      expands: false,
                                      decoration: const InputDecoration(
                                          labelText: TTexts.personalInfoCity, prefixIcon: Icon(Icons.location_city)),
                                    ))
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                      expands: false,
                                      decoration: const InputDecoration(
                                          labelText: TTexts.personalInfoProvince, prefixIcon: Icon(Icons.add_location)),
                                    )),
                                const SizedBox(width: TSizes.spaceBtwInputFields),
                                Expanded(
                                    child: TextFormField(
                                      expands: false,
                                      decoration: const InputDecoration(
                                          labelText: TTexts.personalInfoZipCode, prefixIcon: Icon(Icons.numbers)),
                                    ))
                              ],
                            ),
                            // const SizedBox(height: TSizes.spaceBtwInputFields),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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

                      /// Vehicle Ownership
                      Text(TTexts.vehicleOwnership,
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      RadioListTile(
                          title: const Text('I am an Individual Driver'),
                          value: "value",
                          groupValue: "groupValue",
                          onChanged: (value){}
                      ),
                      RadioListTile(
                          title: const Text('I am a Company Driver'),
                          value: "value",
                          groupValue: "groupValue",
                          onChanged: (value){}
                      ),

                      // RadioListTile<String>(
                      //   title: const Text('I am an Individual Driver'),
                      //   value: 'individual',
                      //   groupValue: '',
                      //   onChanged: (value) {}),
                      // ),
                      // RadioListTile<String>(
                      //   title: const Text('I am a Company Driver'),
                      //   value: 'company',
                      //   groupValue: '',
                      //   onChanged: (value) {},
                      // ),
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
                      side: const BorderSide(
                          color: TColors.primary
                      ),
                    ),
                    onPressed: () => Get.to(() => const UploadDocumentsScreen()),
                    child: const Text(TTexts.tcontinue),
                  )
              )
            ]
          ),
        )
      ),
    );
  }
}
