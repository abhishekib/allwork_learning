import 'package:allwork/utils/colors.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Start fading out after a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    // Navigate to the main menu after fading out
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    // Dynamic sizes
    final imageSize = isLandscape
        ? screenHeight * 0.3
        : screenWidth * 0.4; // 30% height for landscape
    final fontSize = screenWidth * 0.05; // 5% of screen width
    final spacing = screenHeight * 0.03; // 3% of screen height

    return BackgroundWrapper(
      child: Scaffold(
        body: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _opacity,
          child: Center(
            child: isLandscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Column for images
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 20,
                                  spreadRadius: 9,
                                  offset: Offset(8, 8),
                                ),
                              ],
                            ),
                            width: imageSize,
                            height: imageSize,
                            child: Image(
                              image: const AssetImage(
                                  'assets/images/azadar_media.webp'),
                              fit: BoxFit.cover,
                              colorBlendMode: BlendMode.colorBurn,
                            ),
                          ),
                          SizedBox(height: spacing),
                          Container(
                            width: imageSize,
                            height: imageSize,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundBlue,
                              border: Border.all(
                                color: Colors.white,
                                width: 5,
                              ),
                              shape: BoxShape.circle,
                              // boxShadow: const [
                              //   BoxShadow(
                              //     color: Colors.white,
                              //     // blurRadius: 20,
                              //     offset: Offset(0, 0),
                              //   ),
                              // ],
                              image: DecorationImage(
                                image: const AssetImage('assets/app_icon.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: spacing * 2),
                      // Column for text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'In loving Memory of',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Haji Ramzanali Halani',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Maraziya Badur Ali',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Alhajj Shabbirali Mukadam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize * 0.8, // Slightly smaller
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First Image with shadow on bottom and right
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 20,
                              spreadRadius: 9,
                              offset: Offset(8, 8),
                            ),
                          ],
                        ),
                        width: imageSize,
                        height: imageSize,
                        child: Image(
                          image: const AssetImage(
                              'assets/images/azadar_media.webp'),
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.colorBurn,
                        ),
                      ),
                      SizedBox(height: spacing),
                      // Second Image as a circular shape
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 20,
                              offset: Offset(0, 0),
                            ),
                          ],
                          image: DecorationImage(
                            image: const AssetImage('assets/app_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      // Text with responsive font sizes
                      Column(
                        children: [
                          Text(
                            'In loving Memory of',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Haji Ramzanali Halani',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Maraziya Badur Ali',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                          SizedBox(height: spacing / 2),
                          Text(
                            'Alhajj Shabbirali Mukadam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize * 0.8, // Slightly smaller
                              fontWeight: FontWeight.bold,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
