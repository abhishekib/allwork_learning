import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';

class CreditsView extends StatelessWidget {
  const CreditsView({super.key});

  @override
  Widget build(context) {
    return BackgroundWrapper(
        child: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/app_icon.png",
                fit: BoxFit.contain,
                height: 250,
                width: 250,
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Text("Special Thanks", style: AppTextStyles.whiteBoldCreditText),
              Text(
                "Shabanali A Nayani",
                style: AppTextStyles.whiteBoldCreditText,
              ),
              Text("Mukhatarali A Nayani",
                  style: AppTextStyles.whiteBoldCreditText),
              Text("Haji Naji Library",
                  style: AppTextStyles.whiteBoldCreditText),
              Text("Duas Org", style: AppTextStyles.whiteBoldCreditText),
              Text("Ammal and Namaz App",
                  style: AppTextStyles.whiteBoldCreditText),
              Text("Audio Support", style: AppTextStyles.whiteBoldCreditText),
              Text("Debal Bhai Bhojani",
                  style: AppTextStyles.whiteBoldCreditText),
              Text("App Developers Gauri S Prasad",
                  style: AppTextStyles.whiteBoldCreditText)
            ],
          ),
          SizedBox(height: 20),
          Image.asset(
            "assets/images/azadar_media_text.png",
          )
        ],
      ),
    ));
  }
}
