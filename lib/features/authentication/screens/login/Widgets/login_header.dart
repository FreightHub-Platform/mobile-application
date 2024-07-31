import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TLogHeader extends StatelessWidget {
  const TLogHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final dark = THelperFunction.isDarkMode(context);

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TSizes.spaceBtwSections,),
        Image(
          height: 150,
          image: AssetImage(
              dark ? TImages.lightAppLogo : TImages.darkAppLogo),
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        Text(TTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(
          height: TSizes.sm,
        ),
        Text(TTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}