import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freight_hub/data/api/credit_transaction.dart';
import 'package:freight_hub/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../common/widgets/success_screen/success_screen_2.dart';
import '../../../../data/api/get_route_status_mobile.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/texts.dart';
import '../load_board/load_board.dart';
// import '../load_board/load_board_screen.dart';
import '../load_in_transit/load_in_transit.dart';
// import '../load_transit/load_in_transit_screen.dart';
import 'job_report.dart';

class JobCompletedScreen extends StatefulWidget {
  const JobCompletedScreen({super.key});

  @override
  _JobCompletedScreenState createState() => _JobCompletedScreenState();
}

class _JobCompletedScreenState extends State<JobCompletedScreen> {
  bool _isLoading = true;
  bool _isOver = false;

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

        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final posData = responseData['data'][4]['pos'];

          final int? sequenceId = await StorageService.getSequenceId();
          if (sequenceId == null) {
            throw Exception('sequence ID is null');
          }

          setState(() {
            if (sequenceId >= posData.length) {
              // No more POs
              _isOver = true;
            } else {
              _isOver = false;
              StorageService.saveSequenceId(sequenceId + 1);
              StorageService.savePoId(posData[sequenceId]['purchaseOrderId']);
            }
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load route data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading route data: $e')),
      );
    }
  }

  Future<void> _creditMoney() async {
    try {
      final int? routeId = await StorageService.getRouteId();
      if (routeId == null) {
        throw Exception('Route ID is null');
      }

      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final response = await creditTransaction(driverId: driverId, routeId: routeId);

      if (response.statusCode == 200) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Money credited successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Navigate to LoadBoardScreen
        Get.offAll(() => const NavigationMenu());
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to credit money: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error crediting money: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isOver) {
      return SuccessScreen2(
        successTitle: TTexts.loadDelivered,
        successSubTitle: "",
        buttonMessage: "Claim Money",
        onPressed: _creditMoney,
      );
    } else {
      return SuccessScreen2(
        successTitle: TTexts.poCompleteSuccess,
        successSubTitle: "",
        buttonMessage: TTexts.continueDelivery,
        onPressed: () => Get.off(() => const LoadInTransitScreen()),
      );
    }
  }
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../../common/widgets/success_screen/success_screen_2.dart';
// import '../../../../data/api/get_route_status_mobile.dart';
// import '../../../../data/services/storage_service.dart';
// import '../../../../utils/constants/texts.dart';
// import 'job_report.dart';
//
// class JobCompletedScreen extends StatefulWidget {
//   const JobCompletedScreen({super.key});
//
//   @override
//   _JobCompletedScreenState createState() => _JobCompletedScreenState();
// }
//
// class _JobCompletedScreenState extends State<JobCompletedScreen> {
//   bool _isLoading = true;
//   bool _isOver = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRouteData();
//   }
//
//   Future<void> _fetchRouteData() async {
//     try {
//       final int? routeId = await StorageService.getRouteId();
//       if (routeId == null) {
//         throw Exception('route ID is null');
//       }
//
//       final response = await getRouteStatusMobile(routeId: routeId);
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(await response.stream.bytesToString());
//
//         if (responseData['data'] != null && responseData['data'].isNotEmpty) {
//           final posData = responseData['data'][4]['pos'];
//
//           final int? sequenceId = await StorageService.getSequenceId();
//           if (sequenceId == null) {
//             throw Exception('sequence ID is null');
//           }
//
//           setState(() {
//             if (sequenceId >= posData.length) {
//               // No more POs
//               _isOver = true;
//             } else {
//               _isOver = false;
//               StorageService.saveSequenceId(sequenceId + 1);
//               StorageService.savePoId(posData[sequenceId]['purchaseOrderId']);
//             }
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load route data: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading route data: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     if (_isOver) {
//       return SuccessScreen2(
//           successTitle: TTexts.loadDelivered,
//           successSubTitle: "",
//           buttonMessage: "Claim Money",
//           onPressed: () => Get.off(() => const JobReportScreen())
//       );
//     } else {
//       return SuccessScreen2(
//         successTitle: TTexts.poCompleteSuccess,
//         successSubTitle: "",
//         buttonMessage: TTexts.continueDelivery,
//         onPressed: () => Get.off(() => const JobCompletedScreen()),
//       );
//     }
//   }
// }