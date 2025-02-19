import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/about_us_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsView extends StatelessWidget {
  AboutUsView({super.key});
  final AboutUsController _controller = Get.put(AboutUsController());

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'About Us',
            style: AppTextStyles.whiteBoldTitleText,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Linkable(
                        text: _controller.aboutUsText.value,
                        textColor: Colors.white,
                        style: AppTextStyles.whiteBoldText,
                        linkColor: Colors.blue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                final uri = Uri.parse(
                                    'https://azadar.media/whatsappchannel');
                                ;
                                log("Launching $uri");
                                if (!await launchUrl(uri)) {
                                  throw 'Could not launch $uri';
                                }
                              },
                              child: Image.network(width: 60, height: 60,
                                  'https://mafatihuljinan.org/wp-content/uploads/2025/01/download.jpg'))
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
