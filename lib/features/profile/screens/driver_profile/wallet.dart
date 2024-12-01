import 'package:flutter/material.dart';
import 'package:freight_hub/data/api/debit_transaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/api/wallet.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../utils/constants/colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double walletBalance = 0.0;
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final response = await getWallet(driverId: driverId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(await response.stream.bytesToString());
        setState(() {
          walletBalance = double.parse(data['data']['total'].toString());
          transactions = (data['data']['transactions'] as List)
              .map((transaction) => Transaction.fromJson(transaction))
              .toList();
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load wallet data')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error occurred in fetch");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> withdrawMoney() async {
    // Show withdrawal dialog
    final TextEditingController amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance: LKR ${walletBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter withdrawal amount',
                prefixText: 'LKR ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Validate withdrawal amount
                final String amountText = amountController.text.trim();

                // Check if amount is empty
                if (amountText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                  return;
                }

                // Try parsing the amount
                final double? amount = double.tryParse(amountText);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                  return;
                }

                // Validate minimum balance requirement
                if (walletBalance - amount < 1000) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You must maintain a minimum balance of LKR 1,000'),
                    ),
                  );
                  return;
                }

                // Validate withdrawal amount is less than or equal to wallet balance
                if (amount > walletBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Withdrawal amount cannot exceed your wallet balance'),
                    ),
                  );
                  return;
                }

                // Validate minimum withdrawal amount (optional, if needed)
                if (amount < 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Minimum withdrawal amount is LKR 100'),
                    ),
                  );
                  return;
                }

                // Close dialog and submit withdrawal
                Navigator.of(context).pop();
                _submitWithdrawal(amountText);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                side: const BorderSide(color: TColors.primary),
              ),
              child: const Text('Withdraw'),

            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _submitWithdrawal(String amount) async {
    Navigator.of(context).pop(); // Close dialog

    try {
      final int? driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID is null');
      }

      final response = await debitTransaction(
          driverId: driverId,
          amount: double.parse(amount)
      );

      if (response.statusCode == 200) {
        // Refresh wallet data after successful withdrawal
        await fetchWalletData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdrawal successful!')),
        );
      } else {
        // Handle withdrawal error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdrawal failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchWalletData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    'LKR ${walletBalance.toStringAsFixed(2)}',
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
              child: transactions.isEmpty
                  ? const Center(child: Text('No transactions found'))
                  : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    transaction: transactions[index],
                  );
                },
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
                  side: const BorderSide(color: TColors.primary),
                ),
                onPressed: withdrawMoney,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final int id;
  final String type;
  final double amount;
  final DateTime date;
  final String state;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.state,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['transactionTime']),
      state: json['state'] ?? '',
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
              transaction.type == 'credit'
                  ? Icons.add_circle
                  : Icons.remove_circle,
              color: TColors.primary
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type == 'credit' ? 'Ride Payment' : 'Withdraw Money',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  transaction.date.toString().split(' ')[0], // Format as needed
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == 'credit' ? '+' : '-'} LKR ${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: transaction.type == 'credit' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../../../../utils/constants/colors.dart';
//
// class WalletScreen extends StatelessWidget {
//   const WalletScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Driver Wallet'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Wallet Balance
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: TColors.primary,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Wallet Balance',
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'LKR 150,000.00',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // Recent Transactions
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Recent Transactions',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView(
//                 children: const [
//                   TransactionItem(
//                     icon: Icons.add_circle,
//                     label: 'Ride Payment',
//                     amount: '+ LKR 120,000.00',
//                     date: 'July 25, 2024',
//                   ),
//                   TransactionItem(
//                     icon: Icons.remove_circle,
//                     label: 'Withdraw Money',
//                     amount: '- LKR 50,000.00',
//                     date: 'July 24, 2024',
//                   ),
//                   TransactionItem(
//                     icon: Icons.add_circle,
//                     label: 'Ride Payment',
//                     amount: '+ LKR 90,000.00',
//                     date: 'July 23, 2024',
//                   ),
//                   TransactionItem(
//                     icon: Icons.remove_circle,
//                     label: 'Withdraw Money',
//                     amount: '- LKR 20,000.00',
//                     date: 'July 22, 2024',
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // Withdraw Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.attach_money),
//                 label: const Text('Withdraw Money'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: TColors.primary,
//                   side: const BorderSide(
//                       color: TColors.primary
//                   ),
//                 ),
//                 onPressed: () {
//                   // Handle Withdraw Action
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Withdraw action triggered')),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TransactionItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String amount;
//   final String date;
//
//   const TransactionItem({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.amount,
//     required this.date,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: TColors.primary),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 Text(
//                   date,
//                   style: Theme.of(context).textTheme.labelMedium,
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             amount,
//             style: TextStyle(
//               color: amount.startsWith('-') ? Colors.red : Colors.green,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }