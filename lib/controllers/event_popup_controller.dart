import 'package:allwork/modals/event_popup_model.dart';
import 'package:allwork/utils/constants.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/event_popup_provider.dart';

class EventPopupController extends GetxController {
  final isVisible = false.obs;
  final Rx<EventPopupModel?> eventPopupModel = Rx<EventPopupModel?>(null);

  final EventPopupProvider _eventPopupProvider =
      EventPopupProvider(ApiConstants.token);

  @override
  void onInit() {
    super.onInit();
    fetchEventPopup();
  }

  Future<void> fetchEventPopup() async {
    try {
      final response = await _eventPopupProvider.getEventPopup();
      if (response != null && response.imageUrl.isNotEmpty) {
        eventPopupModel.value =
            response; // Correctly assign the model type here
        isVisible.value = true;
      }
    } catch (e) {
      isVisible.value = false;
      print('Error fetching event popup: $e');
    }
  }

  void closeBanner() {
    isVisible.value = false;
  }
}
