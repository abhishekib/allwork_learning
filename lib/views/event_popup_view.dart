import 'package:allwork/controllers/event_popup_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPopupView extends StatelessWidget {
  final EventPopupController eventPopupController =
      Get.put(EventPopupController());

  EventPopupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        eventPopupController.closeBanner();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 450,
          decoration: BoxDecoration(
            color: AppColors.backgroundBlue,
            borderRadius: BorderRadius.circular(10.0),
            // border: Border.all(color: Colors.white, width: 3),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '', // You can dynamically change this text
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      eventPopupController.amalNamazPopupModel.value?.data ??
                          '',
                      fit: BoxFit.cover,
                      // height: 400,
                    ),
                    SizedBox(height: 10),
                    // Text(
                    //   eventPopupController.eventPopupModel.value?.title ?? '',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: Colors.white,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    eventPopupController.closeBanner(); // Close the popup
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
