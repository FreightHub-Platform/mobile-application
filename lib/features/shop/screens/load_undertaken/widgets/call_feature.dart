import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class TCallInfoRow extends StatelessWidget {
  final String location;
  final String? phoneNumber;

  const TCallInfoRow({
    super.key,
    required this.location,
    this.phoneNumber
  });

  void _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: phoneNumber != null
          ? () => _launchCaller(phoneNumber!)
          : null,
      child: Row(
        children: [
          const Icon(Icons.location_on),
          const SizedBox(width: 8),
          Text(location),
          if (phoneNumber != null) ...[
            const Spacer(),
            const Icon(Icons.phone, color: Colors.green),
          ]
        ],
      ),
    );
  }
}