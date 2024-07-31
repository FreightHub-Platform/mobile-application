import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts.dart';
import '../../../utils/helpers/helper_functions.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key,

    required this.onPressed,
    this.hasResendOption = true,
    required this.otpTitle,
    required this.otpSubTitle,
    required this.buttonMessage,
    this.onPressedResend
  });

  final String otpTitle;
  final String otpSubTitle;
  final String buttonMessage;
  final VoidCallback onPressed;
  final bool hasResendOption;
  final VoidCallback? onPressedResend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Get.offAll(() => {}),
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
                    Text(otpTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text("support@freighthub.com",
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(otpSubTitle,
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
                          onPressed: onPressed,
                          child: Text(buttonMessage),
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    hasResendOption ? SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: onPressedResend,
                          child: const Text(TTexts.resentOtp),
                        )) : const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                )
            )
        )
    );
  }
}
