import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';

class MoreAppsView extends StatelessWidget {
  const MoreAppsView({super.key});

  // Define app data here
  static final List<Map<String, String>> apps = [
    {
      'name': 'My Dua Online',
      'imagePath':
          'https://play-lh.googleusercontent.com/MIoC_0t3bgvl9TEkneaagwgGgyaS1LLMAUDVtf8tM9jZO9oQv5o_n8V5G8_iqune3A=s48-rw',
      'url': 'https://mydua.online/app/',
      'text':
          'Elevate your spiritual journey with Mydua Online the app dedicated to audio prayers. Experience authentic Arabic audio and translations in Gujarati, Hindi/Urdu, and English.Event Day to Day Aamaal & Namaz Download now for a divine connection, available whenever you need it http://mydua.online/app'
    },
    {
      'name': 'Azadar Radio',
      'imagePath':
          'https://play-lh.googleusercontent.com/AIYIGMt8RRTKq-t5uzWRnloAiBxMiJJ0HCNWvlipw0R0Gscc0p1FECcQhFDTD77co_Lx=w240-h480-rw',
      'url': 'https://azadar.media/app/',
      'text': 'Check out this app: Azadar Radio\nhttps://azadar.media/app/'
    },
    {
      'name': 'Zawwar',
      'imagePath':
          'https://play-lh.googleusercontent.com/b5OHqb07as4PNd5X-Y-M-yIzEUfNR1fwJhV3_e7-dt0UZNCHu2Iy3Qss18iirEsiLI4=w240-h480-rw',
      'url': 'https://wwbz.media/app',
      'text': 'Check out this app: Zawwar\nhttps://wwbz.media/app'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBlue,
        title: Text(
          'More Apps',
          style: AppTextStyles.whiteBoldTitleText,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return AppCard(
              name: app['name']!,
              imagePath: app['imagePath']!,
              url: app['url']!,
              text: app['text']!,
            );
          },
        ),
      ),
    );
  }
}