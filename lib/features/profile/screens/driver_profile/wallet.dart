import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Wallet Balance
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Wallet Balance',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'LKR 150,000.00',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Recent Transactions
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  TransactionItem(
                    icon: Icons.add_circle,
                    label: 'Ride Payment',
                    amount: '+ LKR 120,000.00',
                    date: 'July 25, 2024',
                  ),
                  TransactionItem(
                    icon: Icons.remove_circle,
                    label: 'Withdraw Money',
                    amount: '- LKR 50,000.00',
                    date: 'July 24, 2024',
                  ),
                  TransactionItem(
                    icon: Icons.add_circle,
                    label: 'Ride Payment',
                    amount: '+ LKR 90,000.00',
                    date: 'July 23, 2024',
                  ),
                  TransactionItem(
                    icon: Icons.remove_circle,
                    label: 'Withdraw Money',
                    amount: '- LKR 20,000.00',
                    date: 'July 22, 2024',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Withdraw Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.attach_money),
                label: const Text('Withdraw Money'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  side: const BorderSide(
                      color: TColors.primary
                  ),
                ),
                onPressed: () {
                  // Handle Withdraw Action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Withdraw action triggered')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final String date;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: TColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amount.startsWith('-') ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}