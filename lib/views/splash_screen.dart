import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/widgets/background_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0;
  bool _imagesPreCached = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images only once.
    if (!_imagesPreCached) {
      precacheImage(
          const AssetImage('assets/images/azadar_media.png'), context);
      precacheImage(const AssetImage('assets/app_icon.png'), context);
      _imagesPreCached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    // Dynamic sizes
    final imageSize = isLandscape ? screenHeight * 0.2 : screenWidth * 0.3;
    final fontSize = screenWidth * 0.05;
    final spacing = screenHeight * 0.03;

    return BackgroundWrapper(
      child: Scaffold(
        body: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: isLandscape
                  ? buildLandscapeContent(imageSize, spacing, fontSize)
                  : buildPortraitContent(imageSize, spacing, fontSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLandscapeContent(
      double imageSize, double spacing, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImageContainer(imageSize),
            SizedBox(height: spacing),
            buildCircularImage(imageSize)
          ],
        ),
        SizedBox(width: spacing * 2),
        buildTextColumn(fontSize, spacing),
      ],
    );
  }

  Widget buildPortraitContent(
      double imageSize, double spacing, double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildImageContainer(imageSize),
        SizedBox(height: spacing),
        buildCircularImage(imageSize),
        SizedBox(height: spacing),
        buildTextColumn(fontSize, spacing),
      ],
    );
  }

  Widget buildImageContainer(double size) {
    return Container(
      width: size,
      height: size,
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
      child: Image(
        image: const AssetImage('assets/images/azadar_media.png'),
        fit: BoxFit.cover,
        colorBlendMode: BlendMode.colorBurn,
      ),
    );
  }

  Widget buildCircularImage(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.backgroundBlue,
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image(
          image: const AssetImage('assets/app_icon.png'),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.colorBurn,
        ),
      ),
    );
  }

  Widget buildTextColumn(double fontSize, double spacing) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'In loving Memory of',
          style: TextStyle(
              color: Colors.red,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif'),
        ),
        SizedBox(height: spacing / 2),
        Text(
          'Haji Ramzanali Halani',
          style: TextStyle(
              color: Colors.green,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif'),
        ),
        SizedBox(height: spacing / 2),
        Text(
          'Maraziya Badur Ali',
          style: TextStyle(
              color: Colors.blue,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif'),
        ),
        SizedBox(height: spacing / 2),
        Text(
          'Alhajj Shabbirali Mukadam',
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 0.8,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif'),
        ),
      ],
    );
  }
}
