import 'dart:developer';
import 'dart:io';

import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/entities/audio_download_mapping_entity.dart';
import 'package:allwork/services/db_services.dart';
import 'package:get/get.dart';

class AudioFileController extends GetxController {
  RxList<AudioDownloadMapping> audioDownloadMappings =
      <AudioDownloadMapping>[].obs;

  List<AudioController> audioControllers = [];

  @override
  void onInit() {
    audioDownloadMappings.value =
        DbServices.instance.getAudioDownloadMappings();
    super.onInit();
  }

  void deleteAudioFile(String audioDownloadpath) {
    audioDownloadMappings.removeWhere(
        (AudioDownloadMapping audioDownloadMapping) =>
            audioDownloadMapping.audioDownloadPath == audioDownloadpath);
    DbServices.instance.deleteAudioDownloadPath(audioDownloadpath);
    final file = File(audioDownloadpath);
    file.delete();
  }

  // String extractAudioName(String audioDownloadpath) {
  //   return audioDownloadpath.split('/').last;
  // }

  @override
  InternalFinalCallback<void> get onDelete {
    log("On delete called");
    for (var controller in audioControllers) {
      controller.onClose();
    }
    return super.onDelete;
  }
}
