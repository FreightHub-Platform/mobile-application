import 'package:flutter/material.dart';
import 'package:freight_hub/data/api/get_route_status_mobile.dart';
import 'package:freight_hub/features/shop/screens/load_in_transit/po_completed.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/start_delivery.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:freight_hub/features/shop/screens/load_undertaken/start_trip.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/call_info_row_widget.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/google_map_launcher.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/widgets/info_row_widget.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/otp_screen/otp_screen.dart';
import '../../../../data/api/update_route_status.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../load_in_transit/load_in_transit.dart';
import '../load_undertaken/widgets/call_feature.dart';

class LoadInTransitScreen extends StatefulWidget {
  const LoadInTransitScreen({super.key});

  @override
  _LoadInTransitScreenState createState() => _LoadInTransitScreenState();
}

class _LoadInTransitScreenState extends State<LoadInTransitScreen> {
  // Variables to store API response data
  String _routeName = 'Loading...';
  String _pickupDate = '*****';
  String _pickupFromTime = '*****';
  String _pickupToTime = '*****';
  double _pickupLat = 0.0;
  double _pickupLng = 0.0;
  List<dynamic> _purchaseOrders = [];
  String _allItemsString = "";
  String _consigner = "";
  String _consignerContact = "";
  String _consignee = "";
  String _consigneeContact = "";

  @override
  void initState() {
    super.initState();
    _fetchRouteData();
  }

  Future<void> _fetchRouteData() async {
    try {

      final int? routeId = await StorageService.getRouteId();
      if (routeId == null) {
        throw Exception('route ID is null');
      }

      final response = await getRouteStatusMobile(routeId: routeId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(await response.stream.bytesToString());

        // Parsing the first order in the data array
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final orderData = responseData['data'][0]['order'];
          final posData = responseData['data'][4]['pos'];
          final consigner = responseData['data'][1]['consignerName'];
          final consignerContact = responseData['data'][2]['consignerContact1'];
          final consignerContact2 = responseData['data'][3]['consignerContact2'];

          // String pickupLocation = consigner;
          // String dropOffLocation = posData[0]['storeName'];
          //
          // StorageService.saveSequenceId(1);
          // StorageService.savePoId(posData[0]['purchaseOrderId']);

          final int? poId = await StorageService.getPoId();
          if (poId == null) {
            throw Exception('route ID is null');
          }

          String pickupLocation = "";
          String dropOffLocation = "";

          final int? sequenceId = await StorageService.getSequenceId();
          if (sequenceId == null) {
            throw Exception('route ID is null');
          } else if (sequenceId == 1) {
            pickupLocation = consigner;
            dropOffLocation = posData[0]['storeName'];

            _consigner = consigner.toString() ?? '';
            _consignerContact = consignerContact.toString() ?? '';
            _consignee = posData[0]['storeName'] ?? '';
            _consigneeContact = posData[0]['storeContact'].toString() ?? '';

          } else {
            pickupLocation = posData[sequenceId - 2]['storeName'];
            dropOffLocation = posData[sequenceId - 1]['storeName'];

            _consigner = consigner.toString() ?? '';
            _consignerContact = consignerContact.toString() ?? '';
            _consignee = posData[sequenceId - 1]['storeName'] ?? '';
            _consigneeContact = posData[sequenceId - 1]['storeContact'].toString() ?? '';
          }

          setState(() {

            // Set pickup location details
            _routeName = 'Driving from $pickupLocation to $dropOffLocation';
            _pickupDate = orderData['pickupDate'] ?? '*****';
            _pickupFromTime = orderData['fromTime'] ?? '*****';
            _pickupToTime = orderData['toTime'] ?? '*****';

            // Set latitude and longitude
            _pickupLat = posData[sequenceId - 1]['dropLat'] ?? 0.0;
            _pickupLng = posData[sequenceId - 1]['dropLng']?? 0.0;

            // Set purchase orders
            _purchaseOrders = posData ?? [];

            _allItemsString = _purchaseOrders[sequenceId-1]['items'].map((item) =>
            "${item['itemName']} (Weight: ${item['weight']}, CBM: ${item['cbm']})"
            ).join(', ');
          });
        }
      } else {
        // Handle error scenario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load route data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading route data: $e')),
      );
    }
  }

  Future<void> _updateRouteStatus() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Get.off(() => const StartTripScreen());
      final int? routeId = await StorageService.getRouteId();
      if (routeId == null) {
        throw Exception('route ID is null');
      }

      final int? dpoId = await StorageService.getPoId();
      if (dpoId == null) {
        throw Exception('Driver ID is null');
      }

      // Make API call to update route status
      final response = await startUnloading(poId: dpoId, routeId: routeId);

      // Close loading indicator
      Navigator.of(context).pop();

      // Check API response
      if (response.statusCode == 200) {
        // Successfully updated status
        Get.off(() => const PoCompletedScreen());
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update route status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading indicator in case of error
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating route status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.sm),
                ),
                color: TColors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(_routeName, style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      // const SizedBox(height: TSizes.spaceBtwItems),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: TColors.black,
                      //       padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                      //       side: const BorderSide(color: TColors.black)
                      //   ),
                      //   onPressed: () {},
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(TTexts.loadInfoTitle),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      TInfoRow(left: 'Date', right: _pickupDate),
                      TInfoRow(left: 'Items to Drop', right: _allItemsString),
                      // TInfoRow(left: 'Pickup From Time', right: _pickupFromTime),
                      // TInfoRow(left: 'Pickup To Time', right: _pickupToTime),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: TSizes.lg / 2, horizontal: TSizes.lg),
                          decoration: const BoxDecoration(
                            color: TColors.info,
                          ),
                          child: Text('Load is Ongoing', style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () {
                  // Use the dynamically fetched latitude and longitude
                  GoogleMapsLauncher.openMapForLocation(
                    latitude: _pickupLat,
                    longitude: _pickupLng,
                    label: 'Drop Off Location', // You can customize this
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(width: 8),
                    Text(TTexts.openInGoogleMap),
                    Spacer(),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Text(TTexts.loadInfoConsignor, style: Theme.of(context).textTheme.headlineSmall),
              // const TCallInfoRow(location: 'Ocean Lanka Pvt. Ltd'),
              // const SizedBox(height: TSizes.spaceBtwItems),
              //
              // Text(TTexts.loadInfoConsignee, style: Theme.of(context).textTheme.headlineSmall),
              // const TCallInfoRow(location: 'MAS Linea Aqua Pvt. Lt'),
              // const SizedBox(height: TSizes.spaceBtwSections),

              Text(TTexts.loadInfoConsignor, style: Theme.of(context).textTheme.headlineSmall),
              TCallInfoRow(
                location: _consigner,
                phoneNumber: _consignerContact,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              Text(TTexts.loadInfoConsignee, style: Theme.of(context).textTheme.headlineSmall),
              TCallInfoRow(
                location: _consignee,
                phoneNumber: _consigneeContact,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                      side: const BorderSide(color: TColors.primary)
                  ),
                  onPressed: () => _updateRouteStatus(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(TTexts.markArrival),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}