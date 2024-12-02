
import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/route_details_screen.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_card_widget.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_controller.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    return routes.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return TLoadBoardCard(
          route: route,
          onTap: route.routeStatus == 'accepted'
              ? () => Get.to(() => RouteDetailsScreen(route: route))
              : null,
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:freight_hub/features/shop/screens/load_undertaken/load_undertaken.dart';
// import 'package:freight_hub/features/shop/screens/load_board/widgets/load_board_card_widget.dart';
// import 'package:freight_hub/utils/constants/sizes.dart';
// import 'package:freight_hub/utils/constants/texts.dart';
//
// class LoadBoardScreen extends StatefulWidget {
//   const LoadBoardScreen({super.key});
//
//   @override
//   _LoadBoardScreenState createState() => _LoadBoardScreenState();
// }
//
// class _LoadBoardScreenState extends State<LoadBoardScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(TTexts.loadBoardTitle),
//         bottom: TabBar(
//           controller: _tabController,
//           labelStyle: const TextStyle(
//             fontSize: 12, // Smaller font size
//             fontWeight: FontWeight.w500, // Adjust weight if needed
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontSize: 12, // Can set different style for unselected tabs
//             fontWeight: FontWeight.w400,
//           ),
//           tabs: const [
//             Tab(text: 'Pending'),
//             Tab(text: 'Confirmed'),
//             Tab(text: 'Completed'),
//             Tab(text: 'Cancelled'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // Pending Tab
//                 _buildLoadCategory('Pending', [
//                   const TLoadBoardCard(
//                     cardTitle: "Biyagama - Katunayake",
//                     consignor: "Pending Consignor 1",
//                     goodType: "Pending Goods",
//                     totalDistance: "Pending Distance",
//                     estimatedProfit: "Pending Profit",
//                   ),
//                   const TLoadBoardCard(
//                     cardTitle: "Colombo - Negombo",
//                     consignor: "Pending Consignor 2",
//                     goodType: "Pending Goods",
//                     totalDistance: "Pending Distance",
//                     estimatedProfit: "Pending Profit",
//                   ),
//                 ]),
//
//                 // Confirmed Tab
//                 _buildLoadCategory('Confirmed', [
//                   const TLoadBoardCard(
//                     cardTitle: "Kandy - Galle",
//                     consignor: "Confirmed Consignor 1",
//                     goodType: "Confirmed Goods",
//                     totalDistance: "Confirmed Distance",
//                     estimatedProfit: "Confirmed Profit",
//                   ),
//                 ]),
//
//                 // Ongoing Tab
//                 _buildLoadCategory('Ongoing', [
//                   const TLoadBoardCard(
//                     cardTitle: "Jaffna - Trincomalee",
//                     consignor: "Ongoing Consignor 1",
//                     goodType: "Ongoing Goods",
//                     totalDistance: "Ongoing Distance",
//                     estimatedProfit: "Ongoing Profit",
//                   ),
//                 ]),
//
//                 // Cancelled Tab
//                 _buildLoadCategory('Cancelled', [
//                   const TLoadBoardCard(
//                     cardTitle: "Matara - Ratnapura",
//                     consignor: "Cancelled Consignor 1",
//                     goodType: "Cancelled Goods",
//                     totalDistance: "Cancelled Distance",
//                     estimatedProfit: "Cancelled Profit",
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Helper method to build each category view
//   Widget _buildLoadCategory(String categoryName, List<Widget> loadCards) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '$categoryName Delivery Requests',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: TSizes.spaceBtwItems),
//             if (loadCards.isNotEmpty) ...loadCards else _buildEmptyState(categoryName),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper method to show empty state when no loads in a category
//   Widget _buildEmptyState(String categoryName) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 100),
//           Icon(
//             Icons.inbox_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: TSizes.spaceBtwItems),
//           Text(
//             'No $categoryName Loads',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: Colors.grey[600],
//             ),
//           ),
//           Text(
//             'All your $categoryName loads will appear here',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }