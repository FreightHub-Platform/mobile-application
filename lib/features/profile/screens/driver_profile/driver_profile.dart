import 'package:flutter/material.dart';
import 'package:freight_hub/features/profile/screens/driver_profile/wallet.dart';
import 'package:freight_hub/features/profile/screens/driver_profile/widgets/information_row.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/driver_profile.jpg'),
              ),
              const SizedBox(height: 20),

              // Driver Name
              Text('John Doe', style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: 10),

              /// Personal Information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                color: TColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Personal Information',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      // Driver Information
                      const InfoRow(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: '+123 456 7890',
                      ),
                      const InfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: 'johndoe@example.com',
                      ),
                      const InfoRow(
                        icon: Icons.location_on,
                        label: 'Address',
                        value: 'New York, USA',
                      ),
                      const InfoRow(
                        icon: Icons.credit_card_rounded,
                        label: 'NIC',
                        value: '200125402750',
                      ),
                      const InfoRow(
                        icon: Icons.account_circle,
                        label: 'Driver Type',
                        value: 'Individual',
                      ),
                    ],
                  )
                ),
              ),

              /// Driving Licence
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                color: TColors.white,
                child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Licence Information',
                            style: Theme.of(context).textTheme.labelMedium),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        // Driver Information
                        const InfoRow(
                          icon: Icons.credit_card,
                          label: 'Driving Licence No',
                          value: '1234567890',
                        ),
                        const InfoRow(
                          icon: Icons.date_range,
                          label: 'Expire Date',
                          value: '2025/09/10',
                        ),
                      ],
                    )
                ),
              ),

              /// Vehicle Information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                color: TColors.white,
                child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Vehicle Information',
                            style: Theme.of(context).textTheme.labelMedium),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        // Driver Information
                        const InfoRow(
                          icon: Icons.local_shipping,
                          label: 'Truck Type',
                          value: '20ft Truck',
                        ),
                        const InfoRow(
                          icon: Icons.credit_card,
                          label: 'Licence Plate No',
                          value: 'ABC-1234',
                        ),
                        const InfoRow(
                          icon: Icons.build,
                          label: 'Make',
                          value: '******',
                        ),
                        const InfoRow(
                          icon: Icons.build_circle,
                          label: 'Model',
                          value: '******',
                        ),
                        const InfoRow(
                          icon: Icons.calendar_today,
                          label: 'Year of Manufacture',
                          value: '2000',
                        ),
                        const InfoRow(
                          icon: Icons.palette,
                          label: 'Vehicle Color',
                          value: 'White',
                        ),
                      ],
                    )
                ),
              ),

              const SizedBox(height: 30),

              // Button to View Wallet
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('View Wallet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(
                        color: TColors.primary
                    ),
                  ),
                  onPressed: () {
                    // Navigate to Wallet Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}