import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freight_hub/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:freight_hub/features/authentication/screens/signup/signup.dart';
import 'package:freight_hub/features/registration/screens/personal_information/required_documents.dart';
import 'package:freight_hub/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../data/api/login.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _apiService = ApiService();

  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final rememberMe = await StorageService.getRememberMe();
    if (rememberMe) {
      final savedEmail = await StorageService.getSavedEmail();
      setState(() {
        _rememberMe = rememberMe;
        if (savedEmail != null) {
          _emailController.text = savedEmail;
        }
      });
    }
  }

  Future<void> _saveToken(String token) async {
    await StorageService.saveToken(token);
    if (_rememberMe) {
      await StorageService.saveRememberMe(true, _emailController.text);
    } else {
      await StorageService.clearSavedCredentials();
    }
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
    return null;
  }

  // Login function
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      try {
        http.StreamedResponse response = await LoginUser(
          username: _emailController.text,
          password: _passwordController.text,
        );

        if (response.statusCode == 200) {

          final responseData = json.decode(await response.stream.bytesToString());

          // Store token if provided in response & remember me
          if (responseData['data']['token'] != null) {
            await _saveToken(responseData['data']['token']);

            // Store Driver ID
            await StorageService.saveDriverId(responseData['data']['id']);

            Get.snackbar(
              'Success',
              'Login successful!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );

            await Future.delayed(const Duration(seconds: 1));
            Get.off(() => const RequiredDocuments());

          } else {
            Get.snackbar(
              'Error',
              'Login Failed!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }

        } else if (response.statusCode == 401) {
          Get.snackbar(
            'Error',
            'Invalid Credentials!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Handle error response
          throw Exception('Login failed: ${response.reasonPhrase}');
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Password
            TextFormField(
              controller: _passwordController,
              validator: _validatePassword,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // Remember Me and Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value ?? false),
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                // Forget Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  side: const BorderSide(color: TColors.primary),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: TColors.primary),
                ),
                onPressed: _isLoading ? null : () => Get.to(() => const SignupScreen()),
                child: const Text(TTexts.createAccount),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:freight_hub/features/authentication/screens/password_configuration/forget_password.dart';
// import 'package:freight_hub/features/authentication/screens/signup/signup.dart';
// import 'package:freight_hub/features/registration/screens/personal_information/required_documents.dart';
// import 'package:freight_hub/navigation_menu.dart';
// import 'package:get/get.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// import '../../../../../utils/constants/colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../../../utils/constants/texts.dart';
//
// class TLoginForm extends StatelessWidget {
//   const TLoginForm({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//             vertical: TSizes.spaceBtwSections),
//         child: Column(
//           children: [
//             /// Email
//             TextFormField(
//               decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.direct_right),
//                   labelText: TTexts.email),
//             ),
//             const SizedBox(height: TSizes.spaceBtwInputFields),
//
//             /// Password
//             TextFormField(
//               decoration: const InputDecoration(
//                   prefixIcon: Icon(Iconsax.password_check),
//                   labelText: TTexts.password,
//                   suffixIcon: Icon(Iconsax.eye_slash)),
//             ),
//             const SizedBox(height: TSizes.spaceBtwInputFields / 2),
//
//             /// Remember me and Forget Password
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 /// Remember Me
//                 Row(
//                   children: [
//                     Checkbox(value: true, onChanged: (value) {}),
//                     const Text(TTexts.rememberMe),
//                   ],
//                 ),
//
//                 /// Forget Password
//                 TextButton(
//                     onPressed: () => Get.to(() => const ForgetPassword() ),
//                     child: const Text(TTexts.forgetPassword))
//               ],
//             ),
//             const SizedBox(height: TSizes.spaceBtwSections),
//
//             /// Sign In Button
//             SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: TColors.primary,
//                       side: const BorderSide(
//                         color: TColors.primary
//                       ),
//                     ),
//                     // onPressed: () => Get.to(() => const NavigationMenu()),
//                     onPressed: () => Get.to(() => const RequiredDocuments()),
//                     child: const Text(TTexts.signIn))),
//             const SizedBox(height: TSizes.spaceBtwItems),
//
//             /// Create Account Button
//             SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                     style: ElevatedButton.styleFrom(
//                       side: const BorderSide(
//                           color: TColors.primary
//                       ),
//                     ),
//                     onPressed: () => Get.to(() => const SignupScreen()),
//                     child: const Text(TTexts.createAccount))),
//             const SizedBox(height: TSizes.spaceBtwSections),
//           ],
//         ),
//       ),
//     );
//   }
// }