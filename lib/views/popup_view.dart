import 'package:allwork/controllers/popup_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/popupEnums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupView extends StatelessWidget {
  final PopupController eventPopupController = Get.put(PopupController());
  final PopupType popupType;

  PopupView(this.popupType, {super.key});

  Future<String?> _getImageUrl() async {
    if (popupType == PopupType.START_POPUP) {
      return 'assets/images/start_popup_image.jpeg';
    }

    if (popupType == PopupType.AMAL_NAMAZ_POPUP &&
        eventPopupController.amalNamazPopupModel.value?.data != null) {
      return eventPopupController.amalNamazPopupModel.value!.data;
    }

    if (popupType == PopupType.EVENT_POPUP &&
        eventPopupController.eventPopupModel.value?.imageUrl != null) {
      return eventPopupController.eventPopupModel.value!.imageUrl;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        String? imageUrl = snapshot.data;

        if (imageUrl == null || imageUrl.isEmpty) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (imageUrl.startsWith('assets'))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imageUrl,
                              fit: BoxFit.contain,
                              height: 350,
                              width: 300,
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text(
                                    'Failed to load image',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        Positioned(
                          top: -40,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: AppColors.backgroundBlue,
                            radius: 16,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              iconSize: 28,
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (eventPopupController.eventPopupModel.value?.title !=
                        null)
                      Text(
                        eventPopupController.eventPopupModel.value!.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
