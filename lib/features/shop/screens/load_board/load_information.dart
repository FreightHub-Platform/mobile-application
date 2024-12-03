import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_info_card_widget.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';

import '../../../../data/api/get_route_all_details.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';

class LoadInformationScreen extends StatefulWidget {
  final RouteModel route;

  const LoadInformationScreen({
    super.key,
    required this.route,
  });

  @override
  _LoadInformationScreenState createState() => _LoadInformationScreenState();
}

class _LoadInformationScreenState extends State<LoadInformationScreen> {
  Future<Map<String, dynamic>>? _loadDetailsFuture;

  @override
  void initState() {
    super.initState();
    _loadDetailsFuture = _fetchLoadDetails();
  }

  Future<Map<String, dynamic>> _fetchLoadDetails() async {
    try {
      // Replace with your actual API endpoint
      final response = await getRouteDetails(routeId: widget.route.routeId);

      if (response.statusCode == 200) {
        return json.decode(await response.stream.bytesToString());
      } else {
        throw Exception('Failed to load load details');
      }
    } catch (e) {
      // Handle any network or parsing errors
      return {
        'error': e.toString(),
      };
    }
  }

  String _formatTime(String? time) {
    if (time == null) return '*****';
    final timeParts = time.split(':');
    if (timeParts.length < 2) return '*****';

    int hour = int.parse(timeParts[0]);
    final minute = timeParts[1];
    String period = 'AM';

    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }

    return '$hour:$minute $period';
  }

  Widget _buildLoadDetailsContent(Map<String, dynamic> apiResponse) {
    if (apiResponse.containsKey('error')) {
      return Center(
        child: Text(
          'Error loading load details: ${apiResponse['error']}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final routeData = apiResponse['data']['route'];
    final orderData = apiResponse['data']['order'];
    final itemSummary = apiResponse['data']['itemSummary'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TLoadBoardInfoCard(
              title: orderData['pickupPoint'] ?? 'Unknown Location',
              consignor: apiResponse['data']['consignerBusinessName'] ?? '*****',
              consignee: apiResponse['data']['purchaseOrders']
                  .where((po) => po['status'] == 'accepted')
                  .map((po) => po['storeName'])
                  .join(', '),
              pickupDate: orderData['pickupDate'] ?? '*****',
              pickupTime: _formatTime(orderData['fromTime']),
              dropOffDate: orderData['pickupDate'] ?? '*****',
              dropOffTime: _formatTime(orderData['toTime']),
              goodType: itemSummary['itemTypeNames']?.isNotEmpty == true
                  ? itemSummary['itemTypeNames'][0]
                  : '*****',
              grossWeight: '${itemSummary['totalWeight'] ?? '*****'} kg',
              totalDistance: '${routeData['actualDistanceKm'] ?? '*****'} km',
              estFuelCost: 'LKR ${routeData['estdCost'] ?? '*****'}',
              estimatedProfit: 'LKR ${routeData['profit'] ?? '*****'}',
              profitPerKm: routeData['profit'] != null && routeData['actualDistanceKm'] != null
                  ? 'LKR ${(routeData['profit'] / routeData['actualDistanceKm']).toStringAsFixed(2)}'
                  : '*****',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TTexts.loadBoardTitle)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }

          return _buildLoadDetailsContent(snapshot.data!);
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_info_card_widget.dart';
// import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';
//
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/texts.dart';
//
// class LoadInformationScreen extends StatelessWidget {
//   final RouteModel route;
//
//   LoadInformationScreen({
//     super.key,
//     required this.route,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text(TTexts.loadBoardTitle)),
//       body: const SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             children: [
//               TLoadBoardInfoCard(
//                 title: "Biyagama - Katunayake",
//                 consignor: "*****",
//                 consignee: "*****",
//                 pickupDate: "*****",
//                 pickupTime: "*****",
//                 dropOffDate: "*****",
//                 dropOffTime: "*****",
//                 goodType: "*****",
//                 grossWeight: "*****",
//                 totalDistance: "*****",
//                 estFuelCost: "*****",
//                 estimatedProfit: "*****",
//                 profitPerKm: "*****",
//               ),
//             ],
//           ),
//         ),
//       ),
//       // bottomNavigationBar: ,
//     );
//   }
// }
