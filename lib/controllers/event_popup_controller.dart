import 'dart:developer';

import 'package:allwork/modals/amal_namaz_popup_model.dart';
import 'package:allwork/modals/event_popup_model.dart';
import 'package:allwork/providers/event_popup_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/views/event_popup_view.dart';
import 'package:get/get.dart';

class EventPopupController extends GetxController {
  final isVisible = false.obs;
  //final Rx<EventPopupModel?> eventPopupModel = Rx<EventPopupModel?>(null);

  final Rx<AmalNamazPopupModel?> amalNamazPopupModel =
      Rx<AmalNamazPopupModel?>(null);
  final EventPopupProvider _eventPopupProvider =
      EventPopupProvider(ApiConstants.token);

  Future<void> fetchEventPopup() async {
    try {
      final response = await _eventPopupProvider.getEventPopup();
      if (response != null) {
        //eventPopupModel.value = response;
        amalNamazPopupModel.value = response;
        isVisible.value = true;
        log("Event Popup Data: $response");

        // Show the event popup dialog
        // if (response.imageUrl != null) {
       Get.dialog(EventPopupView(), barrierDismissible: true);
        // }
      } 
      else {
        // eventPopupModel.value = null;
        isVisible.value = false;
        log("No valid event data found.");
      }
    } catch (e) {
      //eventPopupModel.value = null;
      isVisible.value = false;
      log('Error fetching event popup: $e');
    }
  }

  void closeBanner() {
    isVisible.value = false;
    Get.back(); // Close the popup by popping the dialog
  }
}
