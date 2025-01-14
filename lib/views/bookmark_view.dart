import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "BookMark Screen",
            style: AppTextStyles.whiteBoldTitleText,
          ),
        ),
        body: Center(
          child: Text(
            "Feature is work in progress...",
            style: AppTextStyles.whiteBoldText,
          ),
        ),
      ),
    );
  }
}
