import 'dart:developer';

import 'package:allwork/modals/amal_namaz_popup_model.dart';
import 'package:allwork/modals/event_popup_model.dart';
import 'package:allwork/providers/popup_provider.dart';
import 'package:allwork/utils/constants.dart';
import 'package:allwork/utils/popupEnums.dart';
import 'package:allwork/views/popup_view.dart';
import 'package:get/get.dart';

class PopupController extends GetxController {
  final isVisible = false.obs;
  final Rx<EventPopupModel?> eventPopupModel = Rx<EventPopupModel?>(null);
  final Rx<AmalNamazPopupModel?> amalNamazPopupModel =
      Rx<AmalNamazPopupModel?>(null);

  final PopupProvider _popupProvider = PopupProvider(ApiConstants.token);

  Future<void> fetchStartPopup() async {
    await Get.dialog(
      PopupView(PopupType.START_POPUP),
      barrierDismissible: true,
    );
  }

  Future<void> fetchAmalNamazPopup() async {
    try {
      final response = await _popupProvider.getAmalNamazPopup();
      if (response?.data?.isNotEmpty == true) {
        amalNamazPopupModel.value = response;
        await Get.dialog(
          PopupView(PopupType.AMAL_NAMAZ_POPUP),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      log('Error fetching Amal Namaz popup: $e');
    }
  }

  Future<void> fetchEventPopup() async {
    try {
      final response = await _popupProvider.getEventPopup();
      if (response?.imageUrl?.isNotEmpty == true) {
        eventPopupModel.value = response;
        await Get.dialog(
          PopupView(PopupType.EVENT_POPUP),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      log('Error fetching Event popup: $e');
    }
  }
}
