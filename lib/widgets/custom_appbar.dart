import 'package:allwork/utils/styles.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String title;
  const MyWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          Center(
            child: Text(
              title,
              style: AppTextStyles.whiteBoldTitleText,
            ),
          ),
        ],
      ),
    );
  }
}
