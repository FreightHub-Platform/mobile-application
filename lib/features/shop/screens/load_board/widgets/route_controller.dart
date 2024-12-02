import 'package:freight_hub/data/api/get_pending_routes.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../data/api/get_assigned_routes.dart';
import '../../../../../data/services/storage_service.dart';

class RouteController extends GetxController {
  final RxList<RouteModel> pendingRoutes = <RouteModel>[].obs;
  final RxList<RouteModel> confirmedRoutes = <RouteModel>[].obs;
  final RxList<RouteModel> completedRoutes = <RouteModel>[].obs;
  final RxList<RouteModel> cancelledRoutes = <RouteModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllRoutes();
  }

  Future<void> fetchAllRoutes() async {
    isLoading.value = true;
    error.value = '';

    try {
      // Fetch assigned routes
      await _fetchRoutes('assigned');

      // Fetch driver routes
      await _fetchRoutes('driver');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchRoutes(String endpoint) async {

    // Replace with your actual API endpoint
    final int? driverId = await StorageService.getDriverId();
    if (driverId == null) {
      throw Exception('Driver ID is null');
    }

    final response = (endpoint == "assigned") ? await getAssignedRoutes(driverId: driverId) : await getPendingRoutes(driverId: driverId);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      final List<dynamic> routesJson = data['data'] ?? [];

      final routes = routesJson.map((json) => RouteModel.fromJson(json)).toList();

      // Categorize routes
      for (var route in routes) {
        switch (route.routeStatus) {
          case 'pending':
            pendingRoutes.add(route);
            break;
          case 'accepted':
            confirmedRoutes.add(route);
            break;
          case 'completed':
            completedRoutes.add(route);
            break;
          case 'cancelled':
            cancelledRoutes.add(route);
            break;
        }
      }
    } else {
      throw Exception('Failed to load routes');
    }
  }
}