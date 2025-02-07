import 'package:allwork/modals/category.dart';
import 'package:allwork/services/TextCleanerService.dart';
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
