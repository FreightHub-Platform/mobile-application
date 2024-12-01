import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:freight_hub/features/profile/screens/driver_profile/widgets/information_row.dart';
import '../../../../data/api/get_driver.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  late Map<String, dynamic> driverData = {};
  late Map<String, dynamic> vehicleData = {};
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDriverProfile();
  }

  Future<void> _fetchDriverProfile() async {
    try {
      // Replace with your actual API endpoint
      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final response = await getDriverSingle(driverId: driverId);

      if (response.statusCode == 200) {
        final responseData = json.decode(await response.stream.bytesToString());
        setState(() {
          driverData = responseData['data']['driver'];
          vehicleData = responseData['data']['vehicle'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load driver profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Driver Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Driver Profile')),
        body: Center(child: Text(_errorMessage)),
      );
    }

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
              CircleAvatar(
                radius: 60,
                backgroundImage: driverData['profilePic'] != null
                    ? NetworkImage(driverData['profilePic'])
                    : const AssetImage('assets/images/driver_profile.jpg') as ImageProvider,
              ),
              const SizedBox(height: 20),

              // Driver Name
              Text(
                  '${driverData['fname'] ?? 'N/A'} ${driverData['lname'] ?? ''}',
                  style: Theme.of(context).textTheme.headlineMedium
              ),

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
                        InfoRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: driverData['contactNumber'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: driverData['username'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: '${driverData['addressLine1'] ?? ''}, ${driverData['city'] ?? ''}, ${driverData['province'] ?? ''}',
                        ),
                        InfoRow(
                          icon: Icons.credit_card_rounded,
                          label: 'NIC',
                          value: driverData['nic'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.account_circle,
                          label: 'Driver Type',
                          value: driverData['role'] ?? 'N/A',
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
                        InfoRow(
                          icon: Icons.credit_card,
                          label: 'Driving Licence No',
                          value: driverData['licenseNumber'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.date_range,
                          label: 'Expire Date',
                          value: driverData['licenseExpiry'] ?? 'N/A',
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

                        // Vehicle Information
                        InfoRow(
                          icon: Icons.local_shipping,
                          label: 'Truck Type',
                          value: vehicleData['vtypeId']?['type'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.credit_card,
                          label: 'Licence Plate No',
                          value: vehicleData['licenseNo'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.build,
                          label: 'Make',
                          value: vehicleData['make'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.build_circle,
                          label: 'Model',
                          value: vehicleData['model'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.calendar_today,
                          label: 'Year of Manufacture',
                          value: vehicleData['year'] ?? 'N/A',
                        ),
                        InfoRow(
                          icon: Icons.palette,
                          label: 'Vehicle Color',
                          value: vehicleData['color'] ?? 'N/A',
                        ),
                      ],
                    )
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('** If any details mentioned in USER PROFILE is incorrect or need to be changed, Please contact us immediately via our hotline 0713070420 **',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: TColors.error
                            )
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:freight_hub/features/profile/screens/driver_profile/wallet.dart';
// import 'package:freight_hub/features/profile/screens/driver_profile/widgets/information_row.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/sizes.dart';
//
// class DriverProfileScreen extends StatelessWidget {
//   const DriverProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Driver Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Profile Picture
//               const CircleAvatar(
//                 radius: 60,
//                 backgroundImage: AssetImage('assets/images/driver_profile.jpg'),
//               ),
//               const SizedBox(height: 20),
//
//               // Driver Name
//               Text('John Doe', style: Theme.of(context).textTheme.headlineMedium),
//
//               const SizedBox(height: 10),
//
//               /// Personal Information
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(TSizes.defaultSpace),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Text('Personal Information',
//                           style: Theme.of(context).textTheme.labelMedium),
//                       const SizedBox(height: TSizes.spaceBtwItems),
//
//                       // Driver Information
//                       const InfoRow(
//                         icon: Icons.phone,
//                         label: 'Phone',
//                         value: '+123 456 7890',
//                       ),
//                       const InfoRow(
//                         icon: Icons.email,
//                         label: 'Email',
//                         value: 'johndoe@example.com',
//                       ),
//                       const InfoRow(
//                         icon: Icons.location_on,
//                         label: 'Address',
//                         value: 'New York, USA',
//                       ),
//                       const InfoRow(
//                         icon: Icons.credit_card_rounded,
//                         label: 'NIC',
//                         value: '200125402750',
//                       ),
//                       const InfoRow(
//                         icon: Icons.account_circle,
//                         label: 'Driver Type',
//                         value: 'Individual',
//                       ),
//                     ],
//                   )
//                 ),
//               ),
//
//               /// Driving Licence
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                     padding: const EdgeInsets.all(TSizes.defaultSpace),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         Text('Licence Information',
//                             style: Theme.of(context).textTheme.labelMedium),
//                         const SizedBox(height: TSizes.spaceBtwItems),
//
//                         // Driver Information
//                         const InfoRow(
//                           icon: Icons.credit_card,
//                           label: 'Driving Licence No',
//                           value: '1234567890',
//                         ),
//                         const InfoRow(
//                           icon: Icons.date_range,
//                           label: 'Expire Date',
//                           value: '2025/09/10',
//                         ),
//                       ],
//                     )
//                 ),
//               ),
//
//               /// Vehicle Information
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 color: TColors.white,
//                 child: Padding(
//                     padding: const EdgeInsets.all(TSizes.defaultSpace),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         Text('Vehicle Information',
//                             style: Theme.of(context).textTheme.labelMedium),
//                         const SizedBox(height: TSizes.spaceBtwItems),
//
//                         // Driver Information
//                         const InfoRow(
//                           icon: Icons.local_shipping,
//                           label: 'Truck Type',
//                           value: '20ft Truck',
//                         ),
//                         const InfoRow(
//                           icon: Icons.credit_card,
//                           label: 'Licence Plate No',
//                           value: 'ABC-1234',
//                         ),
//                         const InfoRow(
//                           icon: Icons.build,
//                           label: 'Make',
//                           value: '******',
//                         ),
//                         const InfoRow(
//                           icon: Icons.build_circle,
//                           label: 'Model',
//                           value: '******',
//                         ),
//                         const InfoRow(
//                           icon: Icons.calendar_today,
//                           label: 'Year of Manufacture',
//                           value: '2000',
//                         ),
//                         const InfoRow(
//                           icon: Icons.palette,
//                           label: 'Vehicle Color',
//                           value: 'White',
//                         ),
//                       ],
//                     )
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               // Button to View Wallet
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   icon: const Icon(Icons.account_balance_wallet),
//                   label: const Text('View Wallet'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: TColors.primary,
//                     side: const BorderSide(
//                         color: TColors.primary
//                     ),
//                   ),
//                   onPressed: () {
//                     // Navigate to Wallet Screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const WalletScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }