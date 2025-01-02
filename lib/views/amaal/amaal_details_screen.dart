import 'package:allwork/controllers/text_cleaner_controller.dart';
import 'package:allwork/modals/amaal_model.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';

class AmaalDetailsScreen extends StatelessWidget {
  final Category item;

  const AmaalDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    TextCleanerController textCleanerController = TextCleanerController();

    return BackgroundWrapper(
        child: Scaffold(
            backgroundColor: AppColors.backgroundBlue,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: AppColors.backgroundBlue,
                title: Text(
                  'Amaal Details',
                  style: AppTextStyles.whiteBoldText,
                )),
            body: Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   item.title,
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    // ),
                    Text(
                      textCleanerController.cleanText(item.data!),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
