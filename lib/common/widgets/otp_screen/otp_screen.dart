import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts.dart';
import '../../../utils/helpers/helper_functions.dart';

class OtpScreen extends StatefulWidget {

  const OtpScreen({
    super.key,
    required this.onPressed,
    this.hasResendOption = true,
    required this.otpTitle,
    required this.otpSubTitle,
    required this.buttonMessage,
    required this.validateOtpApi,
    this.onPressedResend
  });

  final String otpTitle;
  final String otpSubTitle;
  final String buttonMessage;
  final Future<bool> Function(String otp) validateOtpApi;
  final bool hasResendOption;
  final VoidCallback? onPressedResend;
  final VoidCallback? onPressed;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _validateOtp() async {
    // Reset previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      // Validate OTP is not empty
      if (_otpController.text.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter OTP';
          _isLoading = false;
        });
        return;
      }

      // Call API to validate OTP
      bool isValid = await widget.validateOtpApi(_otpController.text);

      if (isValid) {
        // Show success message
        Get.snackbar(
          'Success',
          'OTP Verified Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Small delay to show success message
        await Future.delayed(const Duration(seconds: 2));

        // Redirect to next screen
        widget.onPressed!();
      } else {
        // Show error for invalid OTP
        setState(() {
          _errorMessage = 'Invalid OTP. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any API or network errors
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Get.offAll(() => {}),
                icon: const Icon(CupertinoIcons.clear)
            ),
          ],
        ),
        body: SingleChildScrollView(
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
                    Text(widget.otpTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text("support@freighthub.com",
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(widget.otpSubTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// OTP Form
                    Form(
                        child: Column(
                          children: [
                            /// OTP
                            TextFormField(
                              controller: _otpController,
                              expands: false,
                              decoration: InputDecoration(
                                labelText: TTexts.enterOtp,
                                prefixIcon: const Icon(Iconsax.lock),
                                hintText: 'Enter OTP',
                                alignLabelWithHint: true,
                                errorText: _errorMessage,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),
                          ],
                        )
                    ),

                    /// Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          side: const BorderSide(color: TColors.primary),
                        ),
                        onPressed: _isLoading ? null : _validateOtp,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(widget.buttonMessage),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    if (widget.hasResendOption)
                      SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: widget.onPressedResend,
                            child: const Text(TTexts.resentOtp),
                          )
                      )
                    else
                      const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                )
            )
        )
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// import '../../../utils/constants/colors.dart';
// import '../../../utils/constants/image_strings.dart';
// import '../../../utils/constants/sizes.dart';
// import '../../../utils/constants/texts.dart';
// import '../../../utils/helpers/helper_functions.dart';
//
// class OtpScreen extends StatelessWidget {
//   const OtpScreen({super.key,
//
//     required this.onPressed,
//     this.hasResendOption = true,
//     required this.otpTitle,
//     required this.otpSubTitle,
//     required this.buttonMessage,
//     this.onPressedResend
//   });
//
//   final String otpTitle;
//   final String otpSubTitle;
//   final String buttonMessage;
//   final VoidCallback onPressed;
//   final bool hasResendOption;
//   final VoidCallback? onPressedResend;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//                 onPressed: () => Get.offAll(() => {}),
//                 icon: const Icon(CupertinoIcons.clear))
//           ],
//         ),
//         body: SingleChildScrollView(
//           // Padding to give default equal space on all sides in all screens
//             child: Padding(
//                 padding: const EdgeInsets.all(TSizes.defaultSpace),
//                 child: Column(
//                   children: [
//                     /// Image
//                     Image(
//                       image: const AssetImage(TImages.otpIllustration),
//                       width: THelperFunction.getWidth() * 0.6,
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwSections),
//
//                     /// Title & Subtitle
//                     Text(otpTitle,
//                         style: Theme.of(context).textTheme.headlineMedium,
//                         textAlign: TextAlign.center),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     Text("support@freighthub.com",
//                         style: Theme.of(context).textTheme.labelLarge,
//                         textAlign: TextAlign.center),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     Text(otpSubTitle,
//                         style: Theme.of(context).textTheme.labelMedium,
//                         textAlign: TextAlign.center),
//                     const SizedBox(height: TSizes.spaceBtwSections),
//
//                     /// OTP Form
//                     Form(
//                         child: Column(
//                           children: [
//                             /// OTP
//                             TextFormField(
//                               expands: false,
//                               decoration: const InputDecoration(
//                                 labelText: TTexts.enterOtp,
//                                 prefixIcon: Icon(Iconsax.lock),
//                                 hintText: 'Enter OTP', // Example hint text
//                                 alignLabelWithHint: true,
//                               ),
//                               textAlign: TextAlign.center, // Centering the text
//                             ),
//                             const SizedBox(height: TSizes.spaceBtwInputFields),
//                           ],
//                         )),
//
//                     /// Buttons
//                     SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: TColors.primary,
//                             side: const BorderSide(
//                                 color: TColors.primary
//                             ),
//                           ),
//                           onPressed: onPressed,
//                           child: Text(buttonMessage),
//                         )),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     hasResendOption ? SizedBox(
//                         width: double.infinity,
//                         child: TextButton(
//                           onPressed: onPressedResend,
//                           child: const Text(TTexts.resentOtp),
//                         )) : const SizedBox(height: TSizes.spaceBtwItems),
//                   ],
//                 )
//             )
//         )
//     );
//   }
// }
