import 'package:flutter/material.dart';
import 'package:freight_hub/features/shop/screens/job_complete/widgets/table_items.dart';
import 'package:freight_hub/utils/constants/sizes.dart';
import 'package:freight_hub/utils/constants/texts.dart';

import '../../../../utils/constants/colors.dart';

class JobReportScreen extends StatelessWidget {
  const JobReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TTexts.jobReport),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.defaultSpace),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(TSizes.defaultSpace),
                        topRight: Radius.circular(TSizes.defaultSpace),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(TSizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'PO No',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Drop Off',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Distance',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TableItems(
                    po: '12345',
                    location: 'Location A',
                    distance: '10 km',
                  ),
                  const TableItems(
                    po: '56789',
                    location: 'Location B',
                    distance: '100 km',
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.lg, vertical: TSizes.lg / 2),
                  side: const BorderSide(color: TColors.primary),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_money, color: Colors.white),
                    SizedBox(width: TSizes.spaceBtwItems),
                    Text(TTexts.claim,
                        // style: Theme.of(context).textTheme.headlineMedium
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
