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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageUrl;

    if (popupType == PopupType.AMAL_NAMAZ_POPUP) {
      imageUrl = eventPopupController.amalNamazPopupModel.value?.data;
    } else if (popupType == PopupType.EVENT_POPUP) {
      imageUrl = eventPopupController.eventPopupModel.value?.imageUrl;
    } else {
      // Check if START_POPUP has been shown
      bool hasShownStartPopup = prefs.getBool('hasShownStartPopup') ?? false;
      if (!hasShownStartPopup) {
        imageUrl = 'assets/images/start_popup_image.jpeg';
        await prefs.setBool('hasShownStartPopup', true);
      }
    }

    return imageUrl;
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

        // Do not show the popup if no image is available
        if (imageUrl == null || imageUrl.isEmpty) {
          return SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            eventPopupController.closeBanner();
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
                    SizedBox(
                      height: 30,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (imageUrl != null)
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
                                eventPopupController.closeBanner();
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
