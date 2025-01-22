import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditsView extends StatelessWidget {
  const CreditsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Column(
                // Main content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/app_icon.png",
                    fit: BoxFit.contain,
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(height: 10),
                  ..._buildCredits(),
                  SizedBox(height: 20),
                  Flexible(
                    child: Image.asset(
                      "assets/images/azadar_media_text.png",
                    ),
                  ),
                ],
              ),
              Positioned(
                // Custom back button
                top:
                    30, // Adjust top and left values as needed for correct placement
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Colors.white), // Set color to match your design
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCredits() {
    return [
      Text("Special Thanks", style: AppTextStyles.whiteBoldCreditText),
      Text("Shabanali A Nayani", style: AppTextStyles.whiteBoldCreditText),
      Text("Mukhatarali A Nayani", style: AppTextStyles.whiteBoldCreditText),
      Text("Haji Naji Library", style: AppTextStyles.whiteBoldCreditText),
      Text("Duas Org", style: AppTextStyles.whiteBoldCreditText),
      Text("Ammal and Namaz App", style: AppTextStyles.whiteBoldCreditText),
      Text("Audio Support", style: AppTextStyles.whiteBoldCreditText),
      Text("Debal Bhai Bhojani", style: AppTextStyles.whiteBoldCreditText),
      Text("App Developers Gauri S Prasad",
          style: AppTextStyles.whiteBoldCreditText),
    ];
  }
}
