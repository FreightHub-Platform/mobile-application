import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freight_hub/common/widgets/success_screen/success_screen.dart';
import 'package:freight_hub/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:freight_hub/utils/constants/image_strings.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../login/login.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Heading
            Text(TTexts.forgetPassword,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(TTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            /// Text Field
            TextFormField(
              decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Submit Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(
                        color: TColors.primary
                    ),
                  ),
                  onPressed: () => Get.off(() => const ResetPassword()),
                  child: const Text(TTexts.tcontinue),
                )),
          ],
        ),
      ),
    );
  }
}
