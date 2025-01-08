import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String? url;
  final String text;

  const AppCard({
    super.key,
    required this.name,
    required this.imagePath,
    this.url,
    required this.text,
  });

  void _launchURL() async {
    final Uri uri = Uri.parse(url ?? '');
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Opens in an external browser
    )) {
      debugPrint('Could not launch $uri');
    }
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  void _shareApp() {
    final String text = this.text;
    Share.share(text, subject: "Share $name");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: _getImageProvider(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          name,
          style: AppTextStyles.blueBoldText,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: url?.isNotEmpty ?? false,
              child: IconButton(
                icon:
                    const Icon(Icons.download, color: AppColors.backgroundBlue),
                onPressed: _launchURL,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.backgroundBlue),
              onPressed: _shareApp,
            ),
          ],
        ),
      ),
    );
  }
}
