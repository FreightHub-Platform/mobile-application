import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freight_hub/common/widgets/appbar/appbar.dart';
import 'package:freight_hub/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:freight_hub/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:freight_hub/utils/constants/colors.dart';
import 'package:freight_hub/utils/constants/texts.dart';

import '../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_headder_container.dart';
import '../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  THomeAppBar()
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

