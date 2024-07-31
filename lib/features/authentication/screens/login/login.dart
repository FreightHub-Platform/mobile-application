import 'package:flutter/material.dart';
import 'package:freight_hub/common/styles/spacing_styles.dart';
import 'package:freight_hub/utils/constants/colors.dart';
import 'package:freight_hub/utils/constants/image_strings.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/constants/texts.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'Widgets/login_form.dart';
import 'Widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return const Scaffold(
        body: SingleChildScrollView(
        child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                /// Logo, title and sub-title
                TLogHeader(),

                /// Form
                TLoginForm(),

                /// Divider
                // TFormDivider(),

                /// Footer

              ],
            ),
        ),
    ));
  }
}
