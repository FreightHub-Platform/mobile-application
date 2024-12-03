import 'package:flutter/material.dart';
import 'package:freight_hub/data/api/register_driver_2.dart';
import 'package:freight_hub/features/registration/screens/vehicle_information/vehicle_registration.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/texts.dart';
import '../personal_information/widgets/progress_bar.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  _VehicleSelectionScreenState createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int? _selectedVehicleIndex;
  String _selectedCategory = 'Light-Duty';
  bool _isLoading = true;
  String? _error;

  final List<Map<String, dynamic>> vehicleTypes = [
    {
      'v_typeid': 1,
      'length': '7 ft',
      'type': 'Light-Duty',
      'icon': Icons.local_shipping,
      'description': 'Compact truck perfect for local deliveries, small furniture, and tight urban spaces',
    },
    {
      'v_typeid': 2,
      'length': '8 ft',
      'type': 'Light-Duty',
      'icon': Icons.local_shipping,
      'description': 'Versatile truck for home moves, appliance delivery, and small business logistics',
    },
    {
      'v_typeid': 3,
      'length': '10 ft',
      'type': 'Light-Duty',
      'icon': Icons.local_shipping,
      'description': 'Spacious light-duty truck ideal for office equipment, retail inventory, and medium-sized moves',
    },
    {
      'v_typeid': 10,
      'length': '12 ft',
      'type': 'Medium-Duty',
      'icon': Icons.local_shipping,
      'description': 'Robust medium-sized truck for construction materials, multiple room relocations, and commercial cargo',
    },
    {
      'v_typeid': 11,
      'length': '14 ft',
      'type': 'Medium-Duty',
      'icon': Icons.local_shipping,
      'description': 'Versatile carrier for wholesale goods, furniture sets, and medium-scale business shipments',
    },
    {
      'v_typeid': 12,
      'length': '16 ft',
      'type': 'Medium-Duty',
      'icon': Icons.local_shipping,
      'description': 'Expansive truck for large retail orders, extended home moves, and comprehensive commercial deliveries',
    },
    {
      'v_typeid': 13,
      'length': '18 ft',
      'type': 'Medium-Duty',
      'icon': Icons.local_shipping,
      'description': 'Substantial medium-duty truck for industrial equipment, complete office relocations, and bulk merchandise',
    },
    {
      'v_typeid': 15,
      'length': '20 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Powerful truck designed for heavy machinery, large-scale industrial components, and extensive cargo loads',
    },
    {
      'v_typeid': 16,
      'length': '22 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Long-haul heavy-duty vehicle for cross-country shipping, massive equipment transport, and complex logistics',
    },
    {
      'v_typeid': 17,
      'length': '24 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Massive carrier for extensive industrial shipments, complete manufacturing line relocations, and large-scale moves',
    },
    {
      'v_typeid': 18,
      'length': '26 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Expansive heavy-duty truck for comprehensive freight transport, large construction projects, and massive inventory moves',
    },
    {
      'v_typeid': 19,
      'length': '28 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Huge transport solution for international shipping containers, massive equipment, and complex logistical challenges',
    },
    {
      'v_typeid': 20,
      'length': '30 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Enormous capacity truck for extreme heavy-load transportation, full warehouse relocations, and specialized industrial needs',
    },
    {
      'v_typeid': 21,
      'length': '32 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Colossal heavy-duty vehicle for extreme cargo volumes, full-scale industrial moves, and specialized long-distance transport',
    },
    {
      'v_typeid': 22,
      'length': '40 ft',
      'type': 'Heavy-Duty',
      'icon': Icons.local_shipping,
      'description': 'Ultimate heavy-duty transport solution for maximum cargo capacity, international freight, and complex logistical operations',
    }
  ];

  List<Map<String, dynamic>> get _filteredVehicles {
    return vehicleTypes.where((vehicle) => vehicle['type'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Vehicle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TProgressBar(value: 0.4),
              const SizedBox(height: TSizes.spaceBtwSections),
              Center(
                child: Column(
                  children: [
                    Text(
                      'What are you driving?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select the type of vehicle you operate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Category Choice Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Light-Duty',
                    'Medium-Duty',
                    'Heavy-Duty'
                  ].map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = category;
                              _selectedVehicleIndex = null; // Reset vehicle selection
                            });
                          }
                        },
                        selectedColor: TColors.primary.withOpacity(0.2),
                        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Vehicle List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _filteredVehicles[index];
                  final isSelected = _selectedVehicleIndex == vehicleTypes.indexOf(vehicle);

                  return VehicleTypeItem(
                    vehicle: vehicle,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedVehicleIndex = vehicleTypes.indexOf(vehicle);
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    side: const BorderSide(color: TColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _selectedVehicleIndex != null
                      ? () => _submitVehicleSelection(vehicleTypes[_selectedVehicleIndex!])
                      : null,
                  child: const Text(TTexts.tcontinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitVehicleSelection(Map<String, dynamic> vehicle) async {
    setState(() {
      _isLoading = true;
      _error = null; // Reset error
    });

    try {
      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final selectedVTypeId = vehicle['v_typeid'];
      print(selectedVTypeId);

      final response = await registerDriver2(
          driverId: driverId,
          vTypeId: int.tryParse(selectedVTypeId)
      );

      // Get.off(() => const VehicleRegistrationScreen());

      if (response.statusCode == 200) {
        Get.off(() => const VehicleRegistrationScreen());
      } else {
        setState(() {
          _error = 'Failed to submit vehicle selection';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}

class VehicleTypeItem extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleTypeItem({
    Key? key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? TColors.primary.withOpacity(0.1) : isDark ? Colors.grey[900] : Colors.grey[100],
            border: Border.all(
              color: isSelected ? TColors.primary : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? TColors.primary : (isDark ? Colors.grey[800] : Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    vehicle['icon'],
                    size: 24,
                    color: isSelected ? Colors.white : TColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            vehicle['length'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   vehicle['capacity'],
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: isDark ? Colors.grey[400] : Colors.grey[600],
                      //   ),
                      // ),
                      // const SizedBox(height: 4),
                      Text(
                        vehicle['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Radio(
                  value: true,
                  groupValue: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: TColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}