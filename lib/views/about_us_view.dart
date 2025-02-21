import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
                log("About us text:  ${_controller.aboutUsText.value}");
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Html(
                        data: _controller.aboutUsText.value,
                        onLinkTap: (String? url, _, __) async {
                          log("Tapped on url");
                          if (url != null) {
                            final uri = Uri.parse(url);
                            try {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              debugPrint('Could not launch $url: $e');
                            }
                          }
                        },
                        style: {
                          "p": Style(
                              fontSize: FontSize(16),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)
                        },
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
