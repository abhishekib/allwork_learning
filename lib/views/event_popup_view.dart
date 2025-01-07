import 'package:allwork/controllers/popup_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/popupEnums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupView extends StatelessWidget {
  final PopupController eventPopupController = Get.put(PopupController());

  PopupType popupType;

  PopupView(this.popupType, {super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    popupType == PopupType.AMAL_NAMAZ_POPUP
                        ? Image.network(
                            eventPopupController
                                    .amalNamazPopupModel.value?.data ??
                                '',
                            fit: BoxFit.cover,
                            height: 400,
                          )
                        : popupType == PopupType.EVENT_POPUP
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    eventPopupController
                                            .eventPopupModel.value?.title ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Image.network(
                                    eventPopupController
                                            .eventPopupModel.value?.imageUrl ??
                                        '',
                                    fit: BoxFit.cover,
                                    height: 400,
                                  ),
                                ],
                              )
                            : Image.asset(
                                'assets/images/start_popup_image.jpeg',
                                fit: BoxFit.cover,
                                height: 400,
                              ),
                    SizedBox(height: 10),
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
