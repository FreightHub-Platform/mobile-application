import 'package:flutter/material.dart';
import 'package:freight_hub/features/profile/screens/notifications/notifications.dart';
import 'package:freight_hub/features/shop/screens/home/home.dart';
import 'package:freight_hub/utils/constants/colors.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'features/profile/screens/driver_profile/driver_profile.dart';
import 'features/profile/screens/driver_profile/wallet.dart';
import 'features/shop/screens/load_board/load_board.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunction.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : TColors.white,
          indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),

          destinations: const [
            // NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.activity), label: 'Activities'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'Notifications'),
            NavigationDestination(icon: Icon(Iconsax.wallet), label: 'Wallet'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    // const HomeScreen(),
    const LoadBoardScreen(),
    const NotificationsScreen(),
    const WalletScreen(),
    const DriverProfileScreen()
  ];
}
