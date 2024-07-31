import 'package:flutter/material.dart';
import 'package:freight_hub/utils/constants/colors.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'Widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              const TSignUpForm()
            ],
          ),
        ),
      ),
    );
  }
}


