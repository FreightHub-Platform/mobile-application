import 'package:flutter/material.dart';
import 'package:freight_hub/features/authentication/screens/onboarding/onboarding.dart';
import 'package:freight_hub/utils/theme/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

/// -- Use this class to setup themes, initial Bindings, any animations and much
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const OnBoardingScreen(),
    );
    throw UnimplementedError();
  }
}