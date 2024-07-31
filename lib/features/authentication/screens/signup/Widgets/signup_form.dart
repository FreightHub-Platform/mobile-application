import 'package:flutter/material.dart';
import 'package:freight_hub/features/authentication/screens/signup/verify_mobile.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Form(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                  labelText: TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
            )),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            Expanded(
                child: TextFormField(
              expands: false,
              decoration: const InputDecoration(
                  labelText: TTexts.lastName, prefixIcon: Icon(Iconsax.user)),
            ))
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        /// Username
        // TextFormField(
        //   expands: false,
        //   decoration: const InputDecoration(
        //       labelText: TTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
        // ),
        // const SizedBox(height: TSizes.spaceBtwInputFields),

        /// Email
        TextFormField(
          expands: false,
          decoration: const InputDecoration(
              labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        /// Phone Number
        TextFormField(
          expands: false,
          decoration: const InputDecoration(
              labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        /// Password
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: TTexts.password,
            prefixIcon: Icon(Iconsax.password_check),
            suffixIcon: Icon(Iconsax.eye_slash),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        /// Confirm Password
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: TTexts.confirmPassword,
            prefixIcon: Icon(Iconsax.password_check),
            suffixIcon: Icon(Iconsax.eye_slash),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        /// Terms&Conditions checkbox
        Row(
          children: [
            SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(value: true, onChanged: (value) {})),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: '${TTexts.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                  text: TTexts.privacyPolicy,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? TColors.white : TColors.primary,
                      )),
              TextSpan(
                  text: ' ${TTexts.and} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                  text: TTexts.termsOfUse,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? TColors.white : TColors.primary,
                      )),
            ]))
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        /// sign up button
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                side: const BorderSide(
                    color: TColors.primary
                ),
              ),
              onPressed: () => Get.to(() => const VerifyMobileScreen()),
              child: const Text(TTexts.createAccount),
            ))
      ],
    ));
  }
}
