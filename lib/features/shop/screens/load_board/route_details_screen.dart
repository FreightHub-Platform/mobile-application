import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/load_board/widgets/route_model.dart';

class RouteDetailsScreen extends StatelessWidget {
  final RouteModel route;

  const RouteDetailsScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route ${route.routeId} Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Pickup Point', route.pickupPoint),
            _buildDetailRow('Drop Off', route.dropOff),
            _buildDetailRow('Consigner', route.consignerName),
            _buildDetailRow('Distance', '${route.routeDistance} km'),
            _buildDetailRow('Drop Time', route.dropTime),
            _buildDetailRow('Estimated Profit', 'Rs. ${route.estdProfit}'),
            _buildDetailRow('Item Types', route.itemTypes.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}