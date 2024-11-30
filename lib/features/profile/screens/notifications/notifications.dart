import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example notifications data
    final List<Map<String, String>> notifications = [
      {
        'title': 'You have new orders!',
        'description': 'There are new orders that match your vehicle. Go to the load board to take a look!',
        'time': '2 mins ago',
      },
      {
        'title': 'Earnings report',
        'description': 'Your earnings report for the month of July has been prepared. Review your performance!',
        'time': '10 mins ago',
      },
      {
        'title': 'Drive to pick up',
        'description': 'Drive to the pick up location "MAS Pvt ltd" click here to open Google maps.',
        'time': '1 hour ago',
      },
      {
        'title': 'Congratulations on your first order!',
        'description': 'You have successfully completed your first order. Go to the load board to take on more jobs!',
        'time': '3 hours ago',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(notification['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notification['description'] ?? ''),
              trailing: Text(
                notification['time'] ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
              onTap: () {
                // Handle tap on notification (if needed)
              },
            ),
          );
        },
      ),
    );
  }
}