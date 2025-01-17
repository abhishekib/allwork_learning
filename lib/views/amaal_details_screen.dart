import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class AmaalDetailsScreen extends StatelessWidget {
  final Category item;

  const AmaalDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    TextCleanerController textCleanerController = TextCleanerController();

    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            textCleanerController.cleanText(item.title),
            style: AppTextStyles.whiteBoldTitleText,
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
                // onLinkTap:
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
