import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freight_hub/features/authentication/screens/login/login.dart';
import 'package:freight_hub/utils/constants/image_strings.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

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
                      image:
                          const AssetImage(TImages.emailVerificationAnimation),
                      width: THelperFunction.getWidth() * 0.6,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Title & Subtitle
                    Text(TTexts.confirmEmail,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text("support@freighthub.com",
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(TTexts.confirmEmailSubTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwSections),

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
                          onPressed: () => Get.to(() => SuccessScreen(
                                image: TImages.successImage,
                                title: TTexts.yourAccountCreatedTitle,
                                subtitle: TTexts.yourAccountCreatedSubTitle,
                                onPressed: () =>
                                    Get.to(() => const LoginScreen()),
                              )),
                          child: const Text(TTexts.tcontinue),
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(TTexts.resendEmail),
                        )),
                  ],
                ))));
  }
}
