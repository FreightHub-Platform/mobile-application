import 'package:flutter/material.dart';
// import 'package:freight_hub/features/authentication/screens/signup/verify_mobile.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../data/api/register.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import '../../../../../utils/helpers/helper_functions.dart';

import 'package:http/http.dart' as http;

import '../verify_email.dart';

class TSignUpForm extends StatefulWidget {
  const TSignUpForm({super.key});

  @override
  State<TSignUpForm> createState() => _TSignUpFormState();
}

class _TSignUpFormState extends State<TSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Confirm password validation
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // API call for registration
  Future<void> _register() async {
    try {
      setState(() => _isLoading = true);

      print(_emailController.text);
      print(_passwordController.text);

      try {
        http.StreamedResponse response = await registerUser(
          username: _emailController.text,
          password: _passwordController.text,
        );

        if (response.statusCode == 200) {
          Get.snackbar(
            'Success',
            'Account created successfully! Please verify your email.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOutBack,
          );

          await Future.delayed(const Duration(seconds: 1));
          Get.to(() => const VerifyEmailScreen());
        } else {
          // Handle error response
          throw Exception('Registration failed: ${response.reasonPhrase}');
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Registration failed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            validator: _validateEmail,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password field
          TextFormField(
            controller: _passwordController,
            validator: _validatePassword,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: TTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Confirm Password field
          TextFormField(
            controller: _confirmPasswordController,
            validator: _validateConfirmPassword,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: TTexts.confirmPassword,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Terms & Conditions checkbox
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: '${TTexts.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: TTexts.privacyPolicy,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? TColors.white : TColors.primary,
                  ),
                ),
                TextSpan(
                  text: ' ${TTexts.and} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: TTexts.termsOfUse,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? TColors.white : TColors.primary,
                  ),
                ),
              ])),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Sign up button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                side: const BorderSide(color: TColors.primary),
              ),
              onPressed: !_acceptedTerms || _isLoading
                  ? null
                  : () {
                if (_formKey.currentState?.validate() ?? false) {
                  _register();
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}

//
// class TSignUpForm extends StatelessWidget {
//   const TSignUpForm({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunction.isDarkMode(context);
//
//     return Form(
//         child: Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//                 child: TextFormField(
//                   expands: false,
//                   decoration: const InputDecoration(
//                   labelText: TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
//             )),
//             const SizedBox(width: TSizes.spaceBtwInputFields),
//             Expanded(
//                 child: TextFormField(
//               expands: false,
//               decoration: const InputDecoration(
//                   labelText: TTexts.lastName, prefixIcon: Icon(Iconsax.user)),
//             ))
//           ],
//         ),
//         const SizedBox(height: TSizes.spaceBtwInputFields),
//
//         /// Username
//         // TextFormField(
//         //   expands: false,
//         //   decoration: const InputDecoration(
//         //       labelText: TTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
//         // ),
//         // const SizedBox(height: TSizes.spaceBtwInputFields),
//
//         /// Email
//         TextFormField(
//           expands: false,
//           decoration: const InputDecoration(
//               labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
//         ),
//         const SizedBox(height: TSizes.spaceBtwInputFields),
//
//         /// Phone Number
//         TextFormField(
//           expands: false,
//           decoration: const InputDecoration(
//               labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
//         ),
//         const SizedBox(height: TSizes.spaceBtwInputFields),
//
//         /// Password
//         TextFormField(
//           obscureText: true,
//           decoration: const InputDecoration(
//             labelText: TTexts.password,
//             prefixIcon: Icon(Iconsax.password_check),
//             suffixIcon: Icon(Iconsax.eye_slash),
//           ),
//         ),
//         const SizedBox(height: TSizes.spaceBtwInputFields),
//
//         /// Confirm Password
//         TextFormField(
//           obscureText: true,
//           decoration: const InputDecoration(
//             labelText: TTexts.confirmPassword,
//             prefixIcon: Icon(Iconsax.password_check),
//             suffixIcon: Icon(Iconsax.eye_slash),
//           ),
//         ),
//         const SizedBox(height: TSizes.spaceBtwSections),
//
//         /// Terms&Conditions checkbox
//         Row(
//           children: [
//             SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: Checkbox(value: true, onChanged: (value) {})),
//             const SizedBox(width: TSizes.spaceBtwItems),
//             Text.rich(TextSpan(children: [
//               TextSpan(
//                   text: '${TTexts.iAgreeTo} ',
//                   style: Theme.of(context).textTheme.bodySmall),
//               TextSpan(
//                   text: TTexts.privacyPolicy,
//                   style: Theme.of(context).textTheme.bodyMedium!.apply(
//                         color: dark ? TColors.white : TColors.primary,
//                       )),
//               TextSpan(
//                   text: ' ${TTexts.and} ',
//                   style: Theme.of(context).textTheme.bodySmall),
//               TextSpan(
//                   text: TTexts.termsOfUse,
//                   style: Theme.of(context).textTheme.bodyMedium!.apply(
//                         color: dark ? TColors.white : TColors.primary,
//                       )),
//             ]))
//           ],
//         ),
//         const SizedBox(height: TSizes.spaceBtwSections),
//
//         /// sign up button
//         SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: TColors.primary,
//                 side: const BorderSide(
//                     color: TColors.primary
//                 ),
//               ),
//               onPressed: () => Get.to(() => const VerifyMobileScreen()),
//               child: const Text(TTexts.createAccount),
//             ))
//       ],
//     ));
//   }
// }
