import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/event_popup_controller.dart';

class EventPopupBanner extends StatelessWidget {
  final Function onClose;

  EventPopupBanner({super.key, required this.onClose});

  final EventPopupController eventPopupController = Get.put(
      EventPopupController()); // Initialize controller directly in the widget

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventPopupController.isVisible.value &&
          eventPopupController.eventPopupModel.value != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      eventPopupController.eventPopupModel.value!.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        eventPopupController.eventPopupModel.value!.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    eventPopupController.closeBanner();
                    onClose();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink(); // Return nothing if not visible
      }
    });
  }
}
