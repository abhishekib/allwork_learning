import 'package:allwork/controllers/popup_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/popupEnums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupView extends StatelessWidget {
  final PopupController eventPopupController = Get.put(PopupController());

  final PopupType popupType;

  PopupView(this.popupType, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        eventPopupController.closeBanner();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.5, // 90% of the screen width
                maxHeight:
                    constraints.maxHeight * 0.48, // 90% of the screen height
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(10.0),
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
                            '', // Dynamically change this text if needed
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildPopupContent(context),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          eventPopupController.closeBanner(); // Close the popup
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          eventPopupController.eventPopupModel.value?.title ??
                              '',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the popup content dynamically based on the PopupType.
  Widget _buildPopupContent(BuildContext context) {
    if (popupType == PopupType.AMAL_NAMAZ_POPUP) {
      final imageUrl = eventPopupController.amalNamazPopupModel.value?.data;
      return _buildResponsiveImage(imageUrl);
    } else if (popupType == PopupType.EVENT_POPUP) {
      final imageUrl = eventPopupController.eventPopupModel.value?.imageUrl;
      return _buildResponsiveImage(imageUrl);
    } else {
      return _buildResponsiveImage('assets/images/start_popup_image.jpeg',
          isNetworkImage: false);
    }
  }

  /// Dynamically builds a responsive image.
  Widget _buildResponsiveImage(String? imageUrl, {bool isNetworkImage = true}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Text(
        'No Image Available',
        style: TextStyle(color: Colors.white),
      );
    }

    return Flexible(
      child: isNetworkImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
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
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.contain,
            ),
    );
  }
}
