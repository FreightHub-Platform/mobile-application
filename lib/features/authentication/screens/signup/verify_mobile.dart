import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freight_hub/features/authentication/screens/login/login.dart';
import 'package:freight_hub/features/authentication/screens/signup/verify_email.dart';
import 'package:freight_hub/utils/constants/image_strings.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';

class VerifyMobileScreen extends StatelessWidget {
  const VerifyMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Get.offAll(() => const LoginScreen()),
                icon: const Icon(CupertinoIcons.clear))
          ],
        ),
        body: SingleChildScrollView(
            // Padding to give default equal space on all sides in all screens
            child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    /// Image
                    Image(
                      image: const AssetImage(TImages.otpIllustration),
                      width: THelperFunction.getWidth() * 0.6,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Title & Subtitle
                    Text(TTexts.confirmMobileNo,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text("support@freighthub.com",
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(TTexts.confirmMobileNoSubTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// OTP Form
                    Form(
                        child: Column(
                      children: [
                        /// OTP
                        TextFormField(
                          expands: false,
                          decoration: const InputDecoration(
                            labelText: TTexts.enterOtp,
                            prefixIcon: Icon(Iconsax.lock),
                            hintText: 'Enter OTP', // Example hint text
                            alignLabelWithHint: true,
                          ),
                          textAlign: TextAlign.center, // Centering the text
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                      ],
                    )),

                    /// Buttons
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            side: const BorderSide(
                                color: TColors.primary
                            ),
                          ),
                          onPressed: () =>
                              Get.to(() => const VerifyEmailScreen()),
                          child: const Text(TTexts.verify),
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(TTexts.resentOtp),
                        )),
                  ],
                ))));
  }
}
