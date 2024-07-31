import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/widgets/success_screen/success_screen_2.dart';
import '../../../../utils/constants/texts.dart';
import 'job_report.dart';

class JobCompletedScreen extends StatelessWidget {
  const JobCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen2(
          successTitle: TTexts.loadDelivered,
          successSubTitle: "",
          buttonMessage: TTexts.openJobReport,
          onPressed: () => Get.off(() => const JobReportScreen())
    );
  }
}
