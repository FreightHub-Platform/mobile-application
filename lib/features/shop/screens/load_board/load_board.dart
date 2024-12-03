
import 'package:flutter/material.dart';
import 'package:freight_hub/data/services/storage_service.dart';
import 'package:freight_hub/features/shop/screens/load_board/route_details_screen.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_card_widget.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_controller.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';
import 'package:freight_hub/features/shop/screens/load_in_transit/load_in_transit.dart';
import 'package:freight_hub/features/shop/screens/load_in_transit/po_completed.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/start_delivery.dart';
import 'package:freight_hub/features/shop/screens/load_undertaken/mark_arrival.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../load_undertaken/start_trip.dart';

class LoadBoardScreen extends StatefulWidget {
  const LoadBoardScreen({super.key});

  @override
  _LoadBoardScreenState createState() => _LoadBoardScreenState();
}

class _LoadBoardScreenState extends State<LoadBoardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RouteController _routeController = Get.put(RouteController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Check if there are arguments passed to set initial tab
    if (Get.arguments != null && Get.arguments is int) {
      _tabController.index = Get.arguments;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Board'),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),

      body: Obx(() {
        if (_routeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_routeController.error.value.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${_routeController.error.value}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildRouteList(_routeController.pendingRoutes),
            _buildRouteList(_routeController.confirmedRoutes),
            _buildRouteList(_routeController.completedRoutes),
            _buildRouteList(_routeController.cancelledRoutes),
          ],
        );
      }),
    );
  }

  Widget _buildRouteList(RxList<RouteModel> routes) {
    String currentTab = _tabController.index == 0
        ? 'Pending'
        : _tabController.index == 1
        ? 'Confirmed'
        : _tabController.index == 2
        ? 'Completed'
        : 'Cancelled';

    // Add a listener to update when tab changes
    _tabController.addListener(() {
      setState(() {
        currentTab = _tabController.index == 0
            ? 'Pending'
            : _tabController.index == 1
            ? 'Confirmed'
            : _tabController.index == 2
            ? 'Completed'
            : 'Cancelled';
      });
    });

    print("Load Board Current Tab $currentTab");

    return routes.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return TLoadBoardCard(
            route: route,
            currentTab: currentTab,
            onTap: () {
              print('Clicked Route Id: ${route.routeId}');
              StorageService.saveRouteId(route.routeId);
              print('Route Status: ${route.routeStatus}');
              if (route.routeStatus == 'accepted') {
                Get.to(() => const StartTripScreen());  // User can start the route
              } else if (route.routeStatus == 'arriving') {
                Get.to(() => const LoadUndertakenScreen()); //
              } else if (route.routeStatus == 'loading') {
                Get.to(() => const ArrivedToPickupScreen());
              } else if (route.routeStatus == 'ongoing') {
                Get.to(() => const LoadInTransitScreen());
              } else if (route.routeStatus == 'unloading') {
                Get.to(() => const PoCompletedScreen());
              }
            }
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Routes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            'All your routes will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}