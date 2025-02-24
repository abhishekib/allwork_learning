import 'dart:developer';

import 'package:allwork/controllers/deep_linking_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/providers/deep_linking_provider.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class AmaalDetailsScreen extends StatelessWidget {
  final Category item;

  final DeepLinkingController deepLinkingController =
      Get.put(DeepLinkingController());

  AmaalDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              TextCleanerService.cleanText(item.title),
              style: AppTextStyles.whiteBoldTitleText,
            ),
          ),
        ),
        body: Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Make content scrollable
              child: Html(
                data: item.data!,
                onLinkTap: (String? url, _, __) async {
                  if (url != null) {
                    final uri = Uri.parse(url);
                    try {
                      deepLinkingController.handleDeepLink(url);
                    } catch (e) {
                      debugPrint('Could not launch $url: $e');
                    }
                  }
                },
                style: {
                  "p": Style(
                    fontSize: FontSize(16.0),
                    fontWeight: FontWeight.w500,
                  ),
                  "br": Style(
                    display: Display.block,
                    margin: Margins.only(bottom: 10), // Corrected Margins
                  ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
