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

    // Clear existing routes to prevent duplicates
    pendingRoutes.clear();
    confirmedRoutes.clear();
    completedRoutes.clear();
    cancelledRoutes.clear();

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
    final int? driverId = await StorageService.getDriverId();
    print('Driver ID $driverId');
    if (driverId == null) {
      throw Exception('Driver ID is null');
    }

    final response = (endpoint == "assigned")
        ? await getAssignedRoutes(driverId: driverId)
        : await getPendingRoutes(driverId: driverId);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
      final List<dynamic> routesJson = data['data'] ?? [];

      final routes = routesJson.map((json) => RouteModel.fromJson(json)).toList();

      // Categorize routes
      for (var route in routes) {
        _categorizeRoute(route);
      }
    } else {
      throw Exception('Failed to load routes');
    }
  }

  void _categorizeRoute(RouteModel route) {
    switch (route.routeStatus) {
      case 'pending':
        pendingRoutes.add(route);
        break;
      case 'accepted':
        confirmedRoutes.add(route);
        break;
      case 'arriving':
        confirmedRoutes.add(route);
        break;
      case 'loading':
        confirmedRoutes.add(route);
        break;
      case 'ongoing':
        confirmedRoutes.add(route);
        break;
      case 'unloading':
        confirmedRoutes.add(route);
        break;
      case 'completed':
        completedRoutes.add(route);
        break;
      case 'cancelled':
        cancelledRoutes.add(route);
        break;
      case 'unfulfilled':
        cancelledRoutes.add(route);
        break;

    }
  }

  Future<RouteModel> updateRouteStatus(String routeId, String newStatus) async {
    try {
      isLoading.value = true;

      // Get the driver ID
      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      // Prepare the API request
      final uri = Uri.parse('your_base_url/routes/$routeId/status'); // Replace with your actual API endpoint
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token', // Replace with actual authentication
        },
        body: jsonEncode({
          'driverId': driverId,
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the updated route
        final Map<String, dynamic> updatedRouteData = jsonDecode(response.body);
        final updatedRoute = RouteModel.fromJson(updatedRouteData);

        // Remove the route from existing lists
        _removeRouteFromAllLists(routeId);

        // Add to the appropriate list based on new status
        _categorizeRoute(updatedRoute);

        isLoading.value = false;
        return updatedRoute;
      } else {
        throw Exception('Failed to update route status: ${response.body}');
      }
    } catch (e) {
      isLoading.value = false;
      error.value = e.toString();
      throw Exception('Failed to update route status: $e');
    }
  }

  void _removeRouteFromAllLists(String routeId) {
    pendingRoutes.removeWhere((route) => route.routeId == routeId);
    confirmedRoutes.removeWhere((route) => route.routeId == routeId);
    completedRoutes.removeWhere((route) => route.routeId == routeId);
    cancelledRoutes.removeWhere((route) => route.routeId == routeId);
  }
}