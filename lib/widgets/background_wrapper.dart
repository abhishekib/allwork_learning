import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the size of the device
    final screenWidth = MediaQuery.of(context).size.width;

    // Choose the appropriate background image based on screen size
    String backgroundImage;
    if (screenWidth <= 600) {
      // Small screen - phone
      backgroundImage =
          'assets/images/bg_phone.png'; // Path to your uploaded phone background image
    } else if (screenWidth <= 1024) {
      // Medium screen - tablet
      backgroundImage =
          'assets/images/bg_tab.png'; // Path to your uploaded tablet background image
    } else {
      // Large screen - desktop
      backgroundImage =
          'assets/images/bg_desktop.png'; // Path to your uploaded desktop background image
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(28.0),
          child: child,
        ),
      ),
    );
  }
}
