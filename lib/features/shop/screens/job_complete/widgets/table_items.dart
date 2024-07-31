import 'package:flutter/material.dart';

class TableItems extends StatelessWidget {
  const TableItems({
    super.key,
    required this.po,
    required this.location,
    required this.distance,
  });

  final String po;
  final String location;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(po,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(location,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(distance,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}